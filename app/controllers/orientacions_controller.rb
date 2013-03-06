class OrientacionsController < ApplicationController
  require_role [:atencionpublico, :subdireccion], :for => [:new_or_edit, :save]
  require_role "especialistas", :for => [:list_by_user]

  def index
   
  end

  def list_by_user
    @user = current_user
    @estatus = Estatu.find_by_clave("tram-inic")
    @orientaciones = Orientacion.find(:all,
                                       :select => "o.*",
                                       :joins => "o, tramites t",
                                       :conditions => ["o.tramite_id = t.id AND o.user_id = ? AND t.estatu_id = ?", @user.id, @estatus.id],
                                       :order => "o.fechahora")

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
    @orientacion = Orientacion.find(:first, :conditions => ["tramite_id = ?", params[:id]]) if params[:id]
    @orientacion ||= Orientacion.new
    @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
  end

   def save
    #--- Iniciamos trámite --
    @tramite = Tramite.new
    @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
    #@tramite.anio = params[:orientacion]["fechahora(1i)"].to_i
    @tramite.anio = params[:orientacion][:fechahora].split("/")[0]
    @tramite.generar_folio unless @tramite.folio
    @tramite.subdireccion_id = current_user.subdireccion_id unless @tramite.subdireccion
    @tramite.user= current_user
    @orientacion = Orientacion.new(params[:orientacion])
    @orientacion.tramite = @tramite
    @orientacion.especialista_id = User.find(params[:orientacion][:user_id]).id if params[:orientacion][:user_id]
    if @orientacion.save && @tramite.save
      @tramite.update_estatus!("tram-inic", current_user) # update estatus of tramite
        if @orientacion.notificacion
           NotificationsMailer.deliver_tramite_created(@tramite, @orientacion.especialista) #sends the email
           flash[:notice] = "Guardado correctamente y envío de notificación por email" 
        else
          flash[:notice] = "Guardado correctamente, sin envío de notificación por email"
        end
        redirect_to :controller => "home"
    else
      flash[:notice] = "No se pudo guardar, verifique"
      render :action => "new_or_edit"
    end
   end
end
