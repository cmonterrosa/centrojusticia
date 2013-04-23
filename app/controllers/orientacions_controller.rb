class OrientacionsController < ApplicationController
  require_role [:atencionpublico, :subdireccion], :for => [:new_or_edit, :save]
  require_role [:especialistas, :convenios], :for => [:list_by_user]

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
    #--- If is specialist extra ----
    @extra = true if params[:t] == "extra"
    @orientacion = Orientacion.find(:first, :conditions => ["tramite_id = ?", params[:id]]) if params[:id]
    @orientacion ||= Orientacion.new
    if @extra
      @caption = (@extra) ? "CON PERSONAL EXTRAORDINARIO" : ""
      @caption_type_specialist = (@extra) ? "Extraordinario" : ""
      @especialistas = Role.find_by_name("convenios").users.sort{|p1,p2|p1.nombre_completo <=> p2.nombre_completo}
      @especialista = (!@orientacion.especialista_id.nil?) ? User.find(@orientacion.especialista_id) : nil
    else
      especialistas = User.find_by_sql("select u.* from users u inner join roles_users ru on u.id=ru.user_id inner join roles r on ru.role_id=r.id Where r.name = 'especialistas' order by u.login")
      #especialistas.each do |e| e["orientaciones"] = Orientacion.count(:id, :conditions => ["user_id = ? AND fechahora BETWEEN ? AND ?", e.id, 6.months.ago, Time.now])  end
      #@especialistas = especialistas.sort{|p1,p2| p1.orientaciones <=> p2.orientaciones}
      @especialistas = especialistas.sort{|p1,p2| p1.num_orientaciones_por_semana <=> p2.num_orientaciones_por_semana}
      @especialista = (!@orientacion.especialista_id.nil?) ? User.find(@orientacion.especialista_id) : nil
    end
  end

   def save
    #--- Iniciamos trámite --
    @orientacion = Orientacion.find(:first, :conditions => ["id = ?", params[:id]]) if params[:id]
    (@orientacion) ? @orientacion.update_attributes(params[:orientacion]) : @orientacion = Orientacion.new(params[:orientacion])
    @tramite = (@orientacion.tramite) ? @orientacion.tramite : Tramite.new
    @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
    #@tramite.anio = params[:orientacion]["fechahora(1i)"].to_i
    @tramite.anio = params[:orientacion][:fechahora].split("/")[0] if params[:orientacion][:fechahora]
    @tramite.anio ||= Time.now.year
    @tramite.generar_folio unless @tramite.folio
    @tramite.subdireccion_id = current_user.subdireccion_id unless @tramite.subdireccion
    @tramite.user= current_user
    @orientacion.fechahora ||= Time.now
    @orientacion.tramite = @tramite
    @orientacion.especialista_id = User.find(params[:orientacion][:user_id]).id if params[:orientacion][:user_id]
    if @orientacion.save && @tramite.save
      @tramite.update_estatus!("tram-inic", current_user)
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
