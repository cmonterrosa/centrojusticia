#!/bin/env ruby
# encoding: utf-8
class AdminController < ApplicationController
  #before_filter :login_required
   #require_role :admin#, :except => [:index]
   require_role [:direccion, :admindireccion, :adminusuarios]
   #require_role :direccion, :only => [:show_users, :situacion_user, :statistics_user, :permissions_user, :permission_show, :add_permission_user, :permissions_index, :save_permission  ]
   require_role :admin, :only => [:save_user, :add_user]

  def new_area
    
  end


  def index

  end

  #--- administracion de roles y estatus por visualizar
  def roles_estatus
    @role = Role.find(params[:id]) if params[:id]
  end

  def filtro_role
    if params[:role][:id].size > 0
      @role = Role.find(params[:role][:id])
      return render(:partial => 'estatus_by_role', :layout => 'kolaval') #if request.xhr?
    else
      render :text => "No se pudo realizar la búsqueda, verifique"
    end
  end

  def update_role_estatus
    @role = Role.find(params[:id])
    @role.estatus = []
    @role.estatus =  Estatu.find(params[:estatu][:role_ids]) if params[:estatu][:role_ids]
    if @role.save
      flash[:notice] = "Estatus actualizado correctamente"
      redirect_to :action => "roles_estatus"
    end
  end

  #--- administración de flujo de peticiones
  def flujo
    @flujos = Flujo.find(:all, :order => "orden")
    @estatus = Estatu.all
    @users = Role.all
  end

  def add_flujo
    if params[:flujo][:role_id] && params[:flujo][:old_status_id] && params[:flujo][:new_status_id]
       @flujo = Flujo.new(params[:flujo])
       flash[:notice] = (@flujo.save) ?   "Guardado correctamente" :  "No se puedo guardar, verifique"
       redirect_to :action => "flujo"
    else
      flash[:error] = "No se puedo guardar, verifique"
      render :action => "flujo"
    end
  end

  def delete_flujo
    if params[:id]
      @flujo = Flujo.find(params[:id])
      if @flujo.destroy
        flash[:notice] = "Registro eliminado correctamente"
      else
         flash[:error] = "No se pudo eliminar, verifique"
      end
      redirect_to :action => "flujo"
    end
  end


  #------ Administración de materias -----
  def show_materias
    @materias = Materia.find(:all, :order => "descripcion")
  end

  def members_by_materia
    @materia = Materia.find(params[:id])
    @especialistas = []
      Role.find(:first, :conditions => ["name = ?", 'especialistas']).users.each{|user|
        unless @materia.users.include?(user)
          @especialistas << user
        end
      }
  end

  def add_user_materia
    @materia = Materia.find(params[:materia])
    @materia.users << User.find(params[:user][:user_id])
    if @materia.save
      flash[:notice] = "Usuario agregado correctamente"
    else
      flash[:error] = "El usuario no fue agregado, verifique"
    end
    redirect_to :action => "members_by_materia", :id => @materia
  end

    def delete_user_materia
      @materia = Materia.find(params[:materia])
      @user = User.find(params[:id])
      @materia.users.delete(@user)
      if @materia.save!
        flash[:notice] = "Especialista eliminado del perfil correctamente"
      else
        flash[:error] = "No se pudo eliminar, verifique"
      end
      redirect_to :action => "members_by_materia", :id => @materia
    end



  #------- Administracion de Usuarios ---------
  def members_by_role
     @role = Role.find(params[:id])
     @users = []
      User.find(:all).each{|user|
        unless @role.users.include?(user)
          @users << user
        end
      }
  end

  def add_user
  @role = Role.find(params[:role])
  @role.users << User.find(params[:user][:user_id])
  if @role.save
    flash[:notice] = "Usuario agregado correctamente"
  else
    flash[:error] = "El usuario no fue agregado, verifique"
  end
  redirect_to :action => "members_by_role", :id => @role

  end

  def new_user
    @role = Role.find(params[:id])
    @users = []
    User.find(:all).each{|user|
    unless @role.users.include?(user)
      @users << user
    end
    }
  end

  def delete_user
    @role = Role.find(params[:role])
    @user = User.find(params[:id])
     @role.users.delete(@user)
     if @role.save!
       flash[:notice] = "Elemento eliminado del perfil correctamente"
     else
       flash[:error] = "No se pudo eliminar, verifique"
     end
      redirect_to :action => "members_by_role", :id => @role
  end

  def show_roles
    @roles = Role.find(:all)
    @token = generate_token
  end

  def show_users
    if current_user.has_role?("adminusuarios")
      @especialistas = Role.find_by_name("especialistas").todos_usuarios
      @convenios = Role.find_by_name("convenios").todos_usuarios
      @usuarios = User.find(:all, :order => "login, paterno, materno, nombre") if current_user.has_role?("admin")
      @usuarios ||= (@especialistas + @convenios).sort{|a,b| a.nombre_completo <=> b.nombre_completo}
    else
      @usuarios = User.find(:all,  :order => "login, paterno, materno, nombre") if (params[:token] && params[:token]  == 'all' )
      @usuarios ||= User.find(:all, :conditions => ["activo = ?", true], :order => "login, paterno, materno, nombre")
    end
    @usuarios = @usuarios.paginate(:page => params[:page], :per_page => 25)
    @token = generate_token
  end


# -- termina modulo de administracion de usuarios ----

#--- listado de usuarios por area ---

 def show_users_by_area
    @areas = Subdireccion.find(:all, :order => "municipio_id")
 end

 def  update_list_usuarios
     @users = User.find(:all, :conditions => ["subdireccion_id = ?", params[:id]], :order => "paterno, materno, nombre")
     @token = generate_token
     render :layout => false
 end

 def change_horario_estatus
   if validate_token(params[:t]) && @horario= Horario.find(params[:id])
     @mensaje = @horario.activo ? "Horario bloqueado" : "Horario desbloqueado"
     (@horario.activo) ? @horario.update_attributes!(:activo => false) : @horario.update_attributes!(:activo => true)
     flash[:notice] = @mensaje
   else
     flash[:error] = "No se pudo bloquear horario, verifique"
   end
   redirect_to :action => "show_horarios_sesiones"
 end

 def change_user_estatus
   if validate_token(params[:t]) && @user = User.find(params[:id])
     @mensaje = @user.activo ? "Usuario bloqueado" : "Usuario reactivado"
     @baja = Situacion.find_by_descripcion("BAJA")
     @disponible = Situacion.find_by_descripcion("DISPONIBLE")
     url_regreso = (params[:back]) ? {:action => params[:back]} : {:action => "show_users_by_area"}
     (@user.activo) ? @user.update_attributes!(:activo => false, :situacion_id => @baja.id) : @user.update_attributes!(:activo => true, :situacion_id => @disponible.id)
     flash[:notice] = @mensaje
   else
     flash[:error] = "No se pudo bloquear usuario, verifique"
   end
   redirect_to url_regreso
 end


 def change_user_area
   if validate_token(params[:t]) && @user = User.find(params[:id])
     @mensaje = @user.activo ? "Usuario bloqueado" : "Usuario reactivado"
     (@user.activo) ? @user.update_attributes!(:activo => false) : @user.update_attributes!(:activo => true)
     flash[:notice] = @mensaje
   else
     flash[:error] = "No se pudo bloquear usuario, verifique"
   end
   redirect_to :action => "show_users_by_area"
 end

 ######### INICIA ADMINISTRACION DE HORARIOS DE SESIONES ###########

 def show_horarios_sesiones
   @salas = Sala.find(:all, :order=> "descripcion")
   @horarios = Horario.find(:all, :order => "hora,minutos")
   @token= generate_token
 end

 def new_or_edit_horario_sesion
   @horario = Horario.find(params[:id]) if params[:id]
   @horario ||= Horario.new
 end

 def save_horario_sesion
     @horario = Horario.find(params[:id]) if params[:id]
     @horario_anterior = Horario.new(@horario.attributes) if @horario
     @horario ||= Horario.new

     @horario.update_attributes(params[:horario])
     if @horario.save
        ##### UPDATE IF EXISTS WITH THE OLD SCHEDULE ###
        if @horario_anterior
           @sesiones = Sesion.find(:all, :conditions => ["hora = ? AND minutos = ? AND sala_id = ?", @horario_anterior.hora, @horario_anterior.minutos, @horario_anterior.sala_id])
           @sesiones.each do |s|
             s.update_attributes!(:hora => @horario.hora, :minutos => @horario.minutos, :sala_id => @horario.sala_id)
           end
        end

        flash[:notice] = "Horario y sesiones actualizadas correctamente"
        redirect_to :action => "show_horarios_sesiones"
     else
        flash[:error] = "No se pudo actualizar, verifique"
        render :action => "new_or_edit_horario_sesion"
     end
 end

 def edit_user
   unless validate_token(params[:t]) && @user = User.find(params[:id])
    flash[:notice] = "No se pudo encontrar usuario"
    redirect_to :action => "index"
   end
 end

 def save_user
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    @user.activated_at ||= Time.now
    @user.subdireccion = Subdireccion.find(params[:user][:subdireccion_id]) if params[:user][:subdireccion_id]
    @user.activo=true
    success = @user && @user.save
    if success && @user.errors.empty?
      flash[:notice] = "Tus datos se actualizaron correctamente"
      redirect_to :action => "show_users"
    else
      flash[:notice]  = "No se pudieron modificar tus datos, verifica"
      render :action => 'edit_user'
    end
 end

 #---- Human Resources Administration --------

 def situacion_user
   unless validate_token(params[:t]) && @user = User.find(params[:id])
    flash[:notice] = "No se pudo encontrar usuario"
    redirect_to :action => "index"
   end
 end

 def statistics_user
   flash[:notice] = "Función en construcción"
   redirect_to :action => "show_users"
 end

def permissions_user
   if @user = User.find(params[:id])
      @movimientos = Movimiento.find(:all, :conditions => ["user_id = ?", @user.id], :order => "fecha_fin DESC,fecha_inicio DESC").paginate(:page => params[:page], :per_page => 25)
   end
end

def permission_show
  @movimiento = Movimiento.find(params[:id])
end

 def add_permission_user
      @user = User.find(params[:id])
      @situaciones = Situacion.find(:all, :conditions => ["descripcion not in (?)", ["DISPONIBLE", "EN SESION"]])
      @movimiento = Movimiento.new
      @movimiento.user_id = @user.id if @user
 end


 def permissions_index
   
 end


 def permissions_for_people
   @movimiento ||= Movimiento.new
 end

 def save_permission
   @movimiento = Movimiento.new(params[:movimiento])
   @movimiento.autorizo = current_user.id if current_user
   (@movimiento.save) ? flash[:notice] = "Permiso creado correctamente" : flash[:error] = "No se pudo guardar, verifique"
   #update status of current
   redirect_to :action => "permissions_user", :t => generate_token, :id => @movimiento.user
 end

 def search_permissions
   
 end

 def detail_permission
   @movimiento = Movimiento.find(params[:id])
 end

 def cancel_permission
   @movimiento = Movimiento.find(params[:id])
   @user = User.find(params[:user])
   if @movimiento && @user
    flash[:notice] = ( @movimiento.destroy)? "Registro cancelado correctamente" : "Registro no pudo cancelarse, verifique"
   end
   redirect_to :action => "permissions_user", :id => @user, :t => generate_token
 end

 def redit_permission
   @movimiento = Movimiento.find(params[:id])
   @user = User.find(params[:user])
 end

 def update_permission
   @movimiento = Movimiento.find(params[:id])
   @user = User.find(params[:user])
   if @movimiento && @movimiento.update_attributes(params[:movimiento])
     if @movimiento.save
        flash[:notice] = "Registro actualizado correctamente"
        redirect_to :action => "permissions_user", :id => @user, :t => generate_token
     else
       flash[:error] = "No se pudo actualizar, verifique"
       render :action => "redit_permission"
     end
   end
 end

 def show_sesiones_by_user
   @user = User.find(params[:id])
   @sesiones_mediador = Sesion.find(:all, :conditions => ["mediador_id = ? AND concluida != 1", @user.id], :order => "fecha, hora, minutos, created_at")
   @sesiones_comediador = Sesion.find(:all, :conditions => ["comediador_id = ? AND concluida !=1",@user.id], :order => "fecha, hora, minutos, created_at")
 end

 ########### REPORTE DE ATENCIONES NO BRINDADAS ######
 def atenciones_no_brindadas
   @title = "Atenciones no brindadas al público"
   @action = "show_atenciones_no_brindadas"
 end

 def show_atenciones_no_brindadas
   @title = "Atenciones no brindadas al público"
   @action = "show_atenciones_no_brindadas"
    if params[:fecha_inicio] && params[:fecha_fin]
       params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
       @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
    end
    if @inicio && @fin
       @tramites = Tramite.find(:all, :conditions => ["created_at between ? AND ?", @inicio, @fin])
       @justificacion = Justificacion.find_by_descripcion("ESPECIALISTA NO DA ATENCIÓN")
       @historias = Historia.find(:all, :conditions => ["tramite_id in (?) AND justificacion_id = ? AND especialista_id IS NOT NULL", @tramites.map{|t|t.id}, @justificacion.id ])
    else
      flash[:error] = "Parámetros insuficientes, verifique"
      redirect_to :action => "atenciones_no_brindadas"
    end
  end

  ##################################################
  ###      DIAS FESTIVOS O INHABILES
  #################################################

  def festivos
    @festivos = Festivo.find(:all, :order => ["fecha_inicio DESC"])
  end

  def new_festivo
    @festivo = Festivo.new
    @user = current_user
  end

  def save_festivo
    @festivo = Festivo.new(params[:festivo])
    if @festivo.save
      flash[:notice] = "Registro guardado correctamente"
      redirect_to :action => "festivos", :controller => "admin"
    else
      render :action => "festivo"
    end
  end

  def destroy_festivo
    @festivo = Festivo.find(params[:id])
    if @festivo.destroy
      flash[:notice] = "Registro eliminado correctamente"
      redirect_to :controller => "admin", :action => "festivos"
    else
      render :action => "festivo"
    end
  end

  def verificar_integridad
    anio=params[:id].to_i if params[:id]
    anio ||= Time.now.year
    @no_encontrados=[]
    minimo = Tramite.minimum(:folio_expediente, :conditions => ["anio = ?", anio])
    maximo = Tramite.maximum(:folio_expediente, :conditions => ["anio = ?", anio])
    (minimo..maximo).each do |folio_expediente|
        @no_encontrados << "#{anio}/#{folio_expediente}" unless Tramite.count(:folio_expediente, :conditions => ["anio = ? AND folio_expediente = ?", anio, folio_expediente]) > 0
    end
  end


  ####################################################
  #  Motivos de conclusion
  #
  #
  #####################################################

  def motivos_conclusion
    @motivos_conclusion = MotivoConclusion.find(:all)
  end

  def motivos_conclusion_new_or_edit
    @motivo_conclusion = MotivoConclusion.find(params[:id]) if params[:id]
    @motivo_conclusion ||= MotivoConclusion.new
  end

  def motivos_conclusion_save
    begin
      @motivo_conclusion = MotivoConclusion.find(params[:id]) if params[:id]
       @motivo_conclusion ||= MotivoConclusion.new
       @motivo_conclusion.update_attributes(params[:motivo_conclusion])
       if @motivo_conclusion.save
         flash[:notice] = "Motivo guardado correctamente"
       else
         flash[:error] = "Motivo no guardado, verifique"
       end
       redirect_to :action => "motivos_conclusion"
    rescue
        flash[:error] = "Ocurrio un error, contacte al administrador"
        redirect_to  :action => "motivos_conclusion"
    end
  end



end
