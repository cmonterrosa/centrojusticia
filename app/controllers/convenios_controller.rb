class ConveniosController < ApplicationController
  require_role [:especialistas, :convenios, :subdireccion, :direccion]
  
  def list_by_tramite
    @tramite = Tramite.find(params[:id]) if params[:id]
    @convenios = Convenio.find(:all, :conditions => ["tramite_id = ?", @tramite]).paginate(:page => params[:page], :per_page => 25) if @tramite
     render :partial => "list", :layout => "kolaval"
  end

  def list_by_user
    @user = current_user
    if @user.has_role?(:subdireccion)
      @title = "CONVENIOS"
      @convenios = Convenio.find(:all, :order => "fechahora DESC").paginate(:page => params[:page], :per_page => 25) if @user
    else
      @title = "MIS CONVENIOS"
      @convenios = Convenio.find(:all, :conditions => ["especialista_id = ?", @user], :order => "fechahora DESC").paginate(:page => params[:page], :per_page => 25) if @user
    end
    render :partial => "list", :layout => "kolaval"
  end

  def new_or_edit
    @convenio = Convenio.find(params[:id]) if params[:id]
    @convenio ||= Convenio.new
    @tramite = Tramite.find(params[:t]) if params[:t]
    @convenio.tramite = @tramite
  end

  def destroy
     @convenio = Convenio.find(params[:id]) if params[:id]
     @tramite = Tramite.find(params[:t]) if params[:t]
     if @convenio && @convenio.destroy
       flash[:notice] = "Convenio eliminado correctamente"
     else
       flash[:error] = "No se pudo eliminar, verifique"
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
    @tramite = @convenio.tramite = Tramite.find(params[:tramite])
    @convenio.especialista_id = current_user.id
    if @convenio.save
      @tramite.update_estatus!("proc-conv", current_user)
      flash[:notice] = "convenio guardado correctamente"
      redirect_to :action => "list_by_tramite", :id => @convenio.tramite
    else
      flash[:error] = "No se pudo guardar correctamente"
      render :action => "new_or_edit"
    end
  end



end
