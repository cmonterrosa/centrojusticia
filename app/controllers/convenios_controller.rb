class ConveniosController < ApplicationController
  require_role [:especialistas, :convenios, :subdireccion, :direccion]
  
  def list_by_tramite
    @tramite = Tramite.find(params[:id]) if params[:id]
    @convenios = Convenio.find(:all, :conditions => ["tramite_id = ?", @tramite]).paginate(:page => params[:page], :per_page => 25) if @tramite
     render :partial => "list", :layout => "kolaval"
  end

  def search
   select_convenios
   render :partial => "list", :layout => "kolaval"
  end

  def list_by_user
    select_convenios
    render :partial => "list", :layout => "kolaval"
  end

  def new_or_edit
    @convenio = Convenio.find(params[:id]) if params[:id]
    @convenio ||= Convenio.new
    if params[:t]
      @tramite = Tramite.find(params[:t])
      @convenio.tramite = @tramite
    else
      redirect_to :action => "new_or_edit_without_expediente"
    end
  end

  def new_or_edit_without_expediente
    @convenio = Convenio.new
  end

    def validar_num_expediente
    if params[:expediente_num_expediente].size > 5
      unless params[:expediente_num_expediente] =~ /^\d{1,4}\/\d{4}$/
         render :text => "<h4 style='color:#ff9305;'>Formato de expediente no valido</h4>"
      else

        ### Verificamos si existe una sesion con el usuario correspondiente ####
        folio_expediente, anio=params[:expediente_num_expediente].split("/")
        @tramite = (folio_expediente && anio) ? Tramite.find(:first, :conditions => ["anio = ? and folio_expediente = ?", anio, folio_expediente]) : nil
         if @tramite
             @user = User.find(params[:user_id])
             if @user && (@user.has_role?(:convenios) || @user.has_role?(:subdireccion))
                 render :partial => "datos_convenio", :layout => "only_jquery"
             else
                (Sesion.find(:first, :conditions => ["tramite_id = ? AND (mediador_id = ? OR comediador_id = ?) AND (cancel IS NULL or cancel=0)", @tramite.id, params[:user_id], params[:user_id]])) ? (render :partial => "datos_convenio", :layout => "only_jquery") : (render :text => "<h4 style='color:red;'>Expediente le pertenece a otro especialista</h4>")
            end
         else
           (render :text => "<h4 style='color:orange;'>Trámite no válido, contacte al administrador</h4>")
          end
        #(@tramite) ? (render :partial => "datos_convenio", :layout => "only_jquery") : (render :text => "<h4 style='color:red;'>Expediente no encontrado</h4>")
      end
    else
      render :text => ""
    end
  end

  def destroy
     @convenio = Convenio.find(params[:id]) if params[:id]
     @tramite = Tramite.find(params[:t]) if params[:t]
     sucess = @convenio && @convenio.especialista_id == current_user.id
     sucess ||= @convenio && current_user.has_role?(:admin)
     @deleted = @convenio.dup
     if sucess && @convenio.destroy
       write_log("Convenio eliminado correctamente: #{@deleted.inspect}", current_user)
       flash[:notice] = "Convenio eliminado correctamente"
     else
       flash[:error] = "No se pudo eliminar, verifique que tenga privilegios de hacerlo"
     end
     redirect_to :action => "list_by_tramite", :id => @tramite
  end


  def update_adjuntos
    @convenio = Convenio.find(params[:id]) if params[:id]
    @adjuntos = Adjunto.find(:all, :conditions => ["convenio_id = ?", @convenio])
    render :partial => "adjuntos", :layout => "only_jquery"
  end

  def show
      @convenio = Convenio.find(params[:id]) if params[:id]
      @adjuntos = Adjunto.find(:all, :conditions => ["convenio_id = ?", @convenio]) if @convenio
  end

  def validar_invalidar
    if current_user.has_role?(:subdireccion)
      @convenio = Convenio.find(params[:id]) if params[:id]
      new_status = (@convenio.validado) ? false : true
      msj = (new_status) ? 'Convenio validado correctamente' : 'Convenio invalidado correctamente'
      if @convenio && @convenio.update_attributes!(:validado => new_status, :fechahora_validacion => Time.now)
        flash[:notice] = msj
        if @convenio.validado
          @tramite = @convenio.tramite
          @tramite.update_estatus!("conv-vali", current_user)
        end
      else
        flash[:error] = "No se pudo realizar la acción, verifique"
      end
    else
      flash[:error] = "No tiene privilegios para realizar esta acción"
    end
    redirect_to :action => "list_by_user"
  end



   def save
    @convenio = Convenio.find(params[:id]) if params[:id]
    @convenio ||= Convenio.new
    @convenio.update_attributes(params[:convenio])
    @tramite = @convenio.tramite
    @tramite ||= Tramite.find(params[:tramite]) if params[:tramite]
    folio_expediente, anio=params[:expediente][:num_expediente].split("/") if params[:expediente] && params[:expediente][:num_expediente]
    @tramite ||= Tramite.find(:first, :conditions => ["anio = ? and folio_expediente = ?", anio, folio_expediente]) if anio && folio_expediente
    @convenio.tramite = @tramite
    @convenio.especialista_id = current_user.id
    if @convenio.save
      @tramite.update_estatus!("proc-conv", current_user)
      flash[:notice] = "convenio capturado correctamente"
       unless params[:backurl]
          redirect_to :action => "list_by_tramite", :id => @convenio.tramite
       else
         redirect_to :action => params[:backurl]
       end
    else
      flash[:error] = "No se pudo guardar correctamente"
      render :action => "new_or_edit"
    end
  end

 private
 
   def select_convenios
      @user = current_user
      if @user.has_role?(:subdireccion)  || @user.has_role?(:jefeconvenios) || @user.has_role?(:direccion)
        @title = "CONVENIOS"
        @tramites = Tramite.search(params[:search]) if params[:search] && params[:search].size > 0
        @convenios = Convenio.find(:all, :conditions => ["tramite_id in (?)", @tramites.map{|i| i.id}], :order => "fechahora DESC").paginate(:page => params[:page], :per_page => 35) if @tramites && !@tramites.empty?
        @convenios ||= Convenio.find(:all, :order => "fechahora DESC").paginate(:page => params[:page], :per_page => 35) if @user
      else
        @title = "MIS CONVENIOS"
        @tramites = Tramite.search(params[:search]) if params[:search] && params[:search].size > 0
        @convenios = Convenio.find(:all, :conditions => ["especialista_id = ? AND tramite_id in (?)", @user, @tramites.map{|i| i.id}], :order => "fechahora DESC").paginate(:page => params[:page], :per_page => 35) if @tramites && !@tramites.empty?
        @convenios ||= Convenio.find(:all, :conditions => ["especialista_id = ?", @user], :order => "fechahora DESC").paginate(:page => params[:page], :per_page => 25) if @user
      end
   end




end
