class OrientacionsController < ApplicationController
  require_role "especialistas"
  require_role "subdireccion", :for => [:list_all, :filtro_specialista] 

  def index
   
  end

  def list_by_user
    @user = current_user
    @orientaciones = Orientacion.find(:all, :conditions => ["user_id = ?", @user.id], :order => "fechahora")
  end

  def list_all
    @orientaciones = Orientacion.find(:all, :order => "fechahora")
    @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
  end

  def filtro_especialista
    if params[:user_id].size > 0
      @user = User.find(params[:user_id])
      @orientaciones = Orientacion.find(:all, :conditions => ["user_id = ?", @user.id], :order => "fechahora") if @user
    end
    @orientaciones ||= Orientacion.find(:all, :order => "fechahora")
    return render(:partial => 'list_by_user', :layout => false) if request.xhr?
  end

  def change_estatus
    @orientacion = Orientacion.find(params[:id])
    @orientacion.estatu = Estatu.find_by_descripcion(params[:token])
    if @orientacion.save
        flash[:notice] = "Estatus de orientación cambiado correctamente"
    else
        flash[:notice] = "No se puedo cambiar estatus, verifique"
    end
    redirect_to :action => "list_by_user"
  end

  def new_or_edit
    @orientacion ||= Orientacion.new
    @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
  end

   def save
    #--- Iniciamos trámite --
    @tramite = Tramite.new
    @tramite.anio = params[:orientacion]["fechahora(1i)"].to_i
    @tramite.generar_folio unless @tramite.folio
    @tramite.subdireccion_id = current_user.subdireccion_id unless @tramite.subdireccion
    @tramite.user= current_user
    @orientacion = Orientacion.new(params[:orientacion])
    @orientacion.tramite = @tramite
    if @orientacion.save && @tramite.save
      @tramite.update_estatus!("tram-inic", current_user) # update estatus of tramite
      NotificationsMailer.deliver_tramite_created(@tramite, @tramite.user) # sends the email
      flash[:notice] = "Guardado correctamente"
      redirect_to :controller => "home"
    else
      flash[:notice] = "No se pudo guardar, verifique"
      render :action => "new_or_edit"
    end
   end
end
