class SesionesController < ApplicationController
   #before_filter :login_required
   #layout 'oficial', :except => "select_schedule"
    require_role "admin", :only => [:save, :edit]

  def list_by_tramite
    @tramite = Tramite.find(params[:id])
    @sesiones = Sesion.find(:all, :conditions => ["tramite_id = ?", @tramite.id])
  end

  def list_by_user
    if params[:limit] =~ /\d/
      @sesiones_mediador = Sesion.find(:all, :conditions => ["mediador_id = ? AND activa=true", current_user.id], :order => "fecha DESC", :limit => params[:limit])
      @sesiones_comediador = Sesion.find(:all, :conditions => ["comediador_id = ? AND activa=true",current_user.id], :order => "fecha DESC", :limit => params[:limit])
    else
      @sesiones_mediador = Sesion.find(:all, :conditions => ["mediador_id = ?", current_user.id], :order => "fecha DESC")
      @sesiones_comediador = Sesion.find(:all, :conditions => ["comediador_id = ?",current_user.id], :order => "fecha DESC")
    end
  end

  def list_by_fecha
    @fecha = Date.parse(params[:fecha])
    
  end

   def calendario
     @sesiones = Sesion.find(:all, :conditions => ["mediador_id = ? OR comediador_id = ?", current_user.id, current_user.id])
     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
  end

  def show
    @sesion = Sesion.find(params[:id])
    @token = generate_token
    @user = (params[:user])? User.find(params[:user]) : current_user
    current_user ||= User.find(params[:user]) if params[:user]
    
  end

  def new
    @tramite = (params[:id]) ? Tramite.find(params[:id]) : Tramite.new
    @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
  end

  #---- new and save from a day calendar ---
  def new_with_date
    @fecha = Date.parse(params[:date])
    @horarios = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?) and activo=1 group by hora,minutos order by hora,minutos,sala_id", @fecha])
    @horario = Horario.find(params[:horario]) if params[:horario]
    @tipos_sesiones = Tiposesion.find(:all, :order => "descripcion")
    @tramite = (params[:id]) ? Tramite.find(params[:id]) : Tramite.new
    @especialistas = User.find_by_sql(["SELECT u.* FROM users u
    inner join roles_users ru on u.id=ru.user_id
    inner join roles r on ru.role_id=r.id
    where r.name='ESPECIALISTAS' and
    u.id not in (select mediador_id from sesions WHERE activa = 1 AND fecha = ? AND hora= ? AND minutos= ?)", @fecha, @horario.hora, @horario.minutos ])
    #@especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
  end

  def save_with_date
    @origin = params[:origin]
    @sesion = Sesion.new(params[:sesion])
    @horario = Horario.find(params[:horario]) if params[:horario]
    @sesion.horario = @horario if @horario
    @sesion.horario ||= Horario.find(params[:sesion][:horario_id])
    # --- if tramite exists ---
    folio, anio = params[:sesion][:num_tramite].split("/") if params[:sesion][:num_tramite]
    @tramite = Tramite.find(:first, :conditions => ["anio = ? and folio = ?", anio, folio])
    @sesion.tramite = (@tramite) ? @ŧramite : Tramite.create(:folio => folio, :anio => anio, :user_id => current_user.id, :subdireccion_id => current_user.subdireccion_id)
    #@sesion.horario = Horario.find(params[:horario]) if params[:horario]
    @sesion.fecha = Date.parse(params[:date]) if params[:date]
    @sesion.user = current_user
    #--- guardamos historia de hora y minutos ---
    @sesion.hora = @sesion.horario.hora
    @sesion.minutos = @sesion.horario.minutos
    @sesion.sala_id = @sesion.horario.sala_id
    @sesion.activa = true
    if @sesion.save
       @sesion.generate_clave
         #--- Notificaciones ---
         if @sesion.notificacion && @sesion.comediador_id && @sesion.mediador_id
            NotificationsMailer.deliver_sesion_created("mediador", @sesion)
            NotificationsMailer.deliver_sesion_created("comediador", @sesion)
         end
       flash[:notice] = "Sesión guardada correctamente, clave: #{@sesion.clave}"
       redirect_to :action => "daily_show", :controller => "agenda", :day => @sesion.fecha.day, :month=> @sesion.fecha.month, :year => @sesion.fecha.year, :origin => @origin
    else
       flash[:notice] = "no se puedo guardar, verifique"
       render :action => "new_sesion_with_date"
    end

  end

  def save
    @sesion = (params[:sesion_id]) ? Sesion.find(params[:sesion_id])  :  Sesion.new(params[:sesion])
    @redireccion = params[:sesion_id] ? "list_by_user"  :  "list_by_tramite"
    @sesion.update_attributes(params[:sesion])
    @tramite = Tramite.find(params[:id]) if params[:tramite]
    @sesion.tramite = @tramite unless @sesion.tramite
    if @sesion.save
       flash[:notice] = "Sesión guardada correctamente"
       redirect_to :action => @redireccion, :id => @tramite
    else
       flash[:notice] = "no se puedo guardar, verifique"
       render :action => "new"
    end
  end

  def bitacora
    unless (@sesion = Sesion.find(params[:id]))
      redirect_to :action => "list_by_user"
    end
  end

  #######################################################
  #--------- Control y modificacion de sesiones --------
  #######################################################

  def select_schedule
    unless (@sesion = Sesion.find(params[:id]))
      flash[:notice] = "No se pudo encontrar sesion, verifique"
      redirect_to :controller => "home"
    else
      @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
      render :partial => 'select_schedule', :layout => 'oficial'
    end
  end


  def edit
    if (@sesion = Sesion.find(params[:id]))
        @tramite = @sesion.tramite
        @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
    else
      flash[:notice] = "No se pudo encontrar sesion, verifique"
      redirect_to :controller => "home"
    end
  end

  #---------------- Actualización de fecha/hora de sesion -------


  def change_sesion_data
    unless (@sesion = Sesion.find(params[:id]))
      flash[:notice] = "No se pudo encontrar sesion, verifique"
      redirect_to :controller => "home"
    else
      @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
    end
  end

  def show_schedules
   @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
   @salas = Sala.find(:all, :order => "descripcion")
   @sesion= Sesion.find(params[:sesion]) if params[:sesion]
   @mediador = User.find(params[:sesion_mediador_id]) if params[:sesion_mediador_id]
   @comediador = User.find(params[:sesion_comediador_id]) if params[:sesion_comediador_id]
   @horario = Horario.find(params[:horario]) if params[:horario]
   @fecha = Date.parse(params[:sesion_fecha]) if params[:sesion_fecha]
   @noweekend = (1..5).include?(@fecha.wday)
   @horarios = Horario.find_by_sql(["select * from horarios where id not in (select horario_id as id from sesions where fecha = ?)",  @fecha])
   @title = "Resultados encontrados"
   @horarios_disponibles = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?) and activo=1 group by hora,minutos order by hora,minutos,sala_id", @fecha])
  end


  def update_schedule
   @sesion= Sesion.find(params[:sesion]) if params[:sesion]
   @mediador = User.find(params[:mediador]) if params[:mediador]
   @comediador = User.find(params[:comediador]) if params[:comediador]
   @horario = Horario.find(params[:horario]) if params[:horario]
   @fecha = Date.parse(params[:fecha]) if params[:fecha]
   flash[:notice] = "No se pudo actualizar correctamente, verifique"
     if @sesion && @horario && @fecha && @mediador && @comediador
        if @sesion.update_attributes!(:horario_id => @horario.id, :hora => @horario.hora, :minutos => @horario.minutos, :fecha => @fecha, :mediador_id => @mediador.id, :comediador_id => @comediador.id)
           flash[:notice] = "Hora de sesión actualizada correctamente"
        end
    end
     redirect_to :action => "show", :id => @sesion, :user => current_user.id
  end

 def update_schedule2
   #render :text => "Seleccionaste #{params[:mediador]}"
 
    @sesion= Sesion.find(params[:sesion]) if params[:sesion]
   @mediador = User.find(params[:mediador]) if params[:mediador]
   @comediador = User.find(params[:comediador]) if params[:comediador]
   @horario = Horario.find(params[:horario]) if params[:horario]
   @fecha = Date.parse(params[:fecha]) if params[:fecha]
   flash[:notice] = "No se pudo actualizar correctamente, verifique"
     if @sesion && @horario && @fecha && @mediador && @comediador
        if @sesion.update_attributes!(:horario_id => @horario.id, :hora => @horario.hora, :minutos => @horario.minutos, :fecha => @fecha, :mediador_id => @mediador.id, :comediador_id => @comediador.id)
           flash[:notice] = "Hora de sesión actualizada correctamente"
        end
    end
     #redirect_to :action => "show", :id => @sesion, :user => current_user.id
     render :text => "Sesion: #{@sesion.clave} actualizada correctamente"
 end


  def filtro_fecha
    if params[:sesion_fecha]  && params[:sesion_fecha] =~ /^\d{4}\/\d{1,2}\/\d{1,2}$/
      @fecha = params[:sesion_fecha]
      @sesion = Sesion.find(params[:sesion]) if params[:sesion]
      #--- mediador y comediador---
      @mediador = User.find(params[:sesion_mediador_id]) if params[:sesion_mediador_id]
      @comediador = User.find(params[:sesion_comediador_id]) if params[:sesion_comediador_id]
      #---- Seleccion de horarios ---
      @horarios = Horario.find_by_sql(["select * from horarios where id not in (select horario_id as id from sesions where fecha = ?)",  DateTime.parse(@fecha)])
      @title = "Resultados encontrados"
      @horarios_disponibles = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?) and activo=1 group by hora,minutos order by hora,minutos,sala_id", DateTime.parse(@fecha)])
      @salas = Sala.find(:all, :order => "descripcion")
      return render(:partial => 'horarios_disponibles', :layout => "only_jquery")
    else
       return render(:partial => 'no_results', :layout => false)
       #redirect_to :controller => "agenda", :action => "management"
    end
  end

  def cancel
    if ((@sesion = Sesion.find(params[:id])) && validate_token(params[:t]))
        if @sesion.has_permission?(current_user)
             #----- Notificamos a especialistas ---
             NotificationsMailer.deliver_sesion_canceled("mediador", @sesion)
             NotificationsMailer.deliver_sesion_canceled("comediador", @sesion)
            if @sesion.destroy
              flash[:notice] = "Sesión cancelada correctamente, notificación enviada a especialistas.."
              redirect_to :controller => "home"
            else
              flash[:notice] = "No se pudo cancelar, verifique sesión"
              redirect_to :action => "show", :id => @sesion
           end
        end
    elsif params[:id]
        flash[:notice] = "Token de seguridad incorrecto"
        redirect_to :action => "show", :id => params[:id]
    else
        redirect_to :controller => "home"
    end
  end


end
