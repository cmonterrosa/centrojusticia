class SesionesController < ApplicationController
   #before_filter :login_required
   #layout 'oficial', :except => "select_schedule"
    #require_role "admin", :only => [:save, :edit]
    #require_role [:especialistas, :admindireccion], :for => [:new, :list_by_user, :list_by_tramite]
    #require_role [:controlagenda, :admindireccion], :for => [:new_with_date]
    require_role [:lecturaagenda, :admindireccion, :especialistas, :direccion, :asignahorario]
    require_role [:controlagenda, :admindireccion], :for => [:reprogramar, :new_with_date, :cancel]

  def list_by_tramite
    @tramite = Tramite.find(params[:id])
    @sesiones = Sesion.find(:all, :conditions => ["tramite_id = ?", @tramite.id])
  end

  def asignar_horario
    unless (@sesion = Sesion.find(params[:id]))
      flash[:notice] = "No se pudo encontrar sesion, verifique"
      redirect_to :controller => "home"
    else
      @title = (params[:title]) ? "Resignación de horario" : "Asignación de horario"
      @mediador = User.find(params[:mediador_id])
      @comediador = User.find(params[:comediador_id])
      @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
      @notificacion = (params[:sesion_notificacion]) ? true : false
    end
   end

  def list_by_user
    if params[:activas]
      case params[:activas].to_i
        when 1
            @sesiones_mediador = Sesion.find(:all, :conditions => ["mediador_id = ? AND concluida != 1", current_user.id], :order => "fecha, hora, minutos, created_at", :limit => 20)
            @sesiones_comediador = Sesion.find(:all, :conditions => ["comediador_id = ? AND concluida !=1",current_user.id], :order => "fecha, hora, minutos, created_at", :limit => 20)
        when 0
            @sesiones_mediador = Sesion.find(:all, :conditions => ["mediador_id = ? AND concluida = 1", current_user.id], :order => "fecha, hora, minutos, created_at", :limit => 20)
            @sesiones_comediador = Sesion.find(:all, :conditions => ["comediador_id = ? AND concluida = 1", current_user.id], :order => "fecha, hora, minutos, created_at", :limit => 20)
      end
    end
    @sesiones_mediador ||= Sesion.find(:all, :conditions => ["mediador_id = ?", current_user.id], :order => "fecha, hora, minutos, created_at")
    @sesiones_comediador ||= Sesion.find(:all, :conditions => ["comediador_id = ?",current_user.id], :order => "fecha, hora, minutos, created_at")
  end

  def list_by_fecha
    @fecha = Date.parse(params[:fecha])
    
  end

   def calendario
     @sesiones = Sesion.find(:all, :conditions => ["mediador_id = ? OR comediador_id = ?", current_user.id, current_user.id])
     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
  end

   #---- tentativamente lo eliminaremos -----
  def show
    @sesion = Sesion.find(params[:id])
    @token = generate_token
    @user = (params[:user])? User.find(params[:user]) : current_user
    current_user ||= User.find(params[:user]) if params[:user]
  end

  def show_window
    @token = generate_token
    @user = (params[:user])? User.find(params[:user]) : current_user
    current_user ||= User.find(params[:user]) if params[:user]
    @sesion = Sesion.find(params[:id]) if params[:id]
    @tramite = @sesion.tramite if @sesion
    render :partial => 'show', :layout => 'only_jquery'
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
##    @especialistas = User.find_by_sql(["SELECT u.* FROM users u
#    inner join roles_users ru on u.id=ru.user_id
#    inner join roles r on ru.role_id=r.id
#    where r.name='ESPECIALISTAS' and
#    u.id not in (select mediador_id from sesions WHERE activa = 1 AND fecha = ? AND hora= ? AND minutos= ?) AND
#    u.id not in (select comediador_id from sesions WHERE activa = 1 AND fecha = ? AND hora= ? AND minutos= ?) ORDER BY u.nombre, u.paterno, u.materno#", @fecha, @horario.hora, @horario.minutos, @fecha, @horario.hora, @horario.minutos ])

    @sesion = Sesion.new
    @sesion.fecha = @fecha
    @sesion.horario = @horario
    @fecha_hora_sesion = (@sesion.start_at) ? @sesion.start_at : nil
    #@especialistas = Role.find_by_name("ESPECIALISTAS").usuarios_disponibles_sesiones(@fecha_hora_sesion)
    @mediadores =  Role.find_by_name("ESPECIALISTAS").usuarios_disponibles_sesiones_funcion(@fecha_hora_sesion, "mediador")
    @comediadores = Role.find_by_name("ESPECIALISTAS").usuarios_disponibles_sesiones_funcion(@fecha_hora_sesion, "comediador")


    if current_user.has_role?("admindireccion")
      render :partial => 'new_with_date', :layout => 'oficial'
    else
      flash[:notice] = "No tiene privilegios, consulte al administrador del sistema"
      render :action => "home"
    end


    @fecha = Date.parse(params[:date])
    @horarios = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?) and activo=1 group by hora,minutos order by hora,minutos,sala_id", @fecha])
    @horario = Horario.find(params[:horario]) if params[:horario]
    @tipos_sesiones = Tiposesion.find(:all, :order => "descripcion")
    @tramite = (params[:id]) ? Tramite.find(params[:id]) : Tramite.new
    @especialistas = User.find_by_sql(["SELECT u.* FROM users u
    inner join roles_users ru on u.id=ru.user_id
    inner join roles r on ru.role_id=r.id
    where r.name='ESPECIALISTAS' and
    u.id not in (select mediador_id from sesions WHERE activa = 1 AND fecha = ? AND hora= ? AND minutos= ?) AND
    u.id not in (select comediador_id from sesions WHERE activa = 1 AND fecha = ? AND hora= ? AND minutos= ?) ORDER BY u.nombre, u.paterno, u.materno", @fecha, @horario.hora, @horario.minutos, @fecha, @horario.hora, @horario.minutos ])


  end

  def save_with_date
    @origin = params[:origin]
    @sesion = Sesion.new(params[:sesion])
    @mediador = (params[:sesion][:mediador_id] =~ /^\d{1,5}$/)? User.find(params[:sesion][:mediador_id]) : nil
    @comediador = (params[:sesion][:comediador_id] =~ /^\d{1,5}$/)? User.find(params[:sesion][:comediador_id]) : nil
    @horario = Horario.find(params[:horario]) if params[:horario]
    @sesion.horario = @horario if @horario
    @sesion.horario ||= Horario.find(params[:sesion][:horario_id])
    #---- if tramite has a valid format -----
    
    if params[:sesion][:num_tramite] =~ /^\d{1,4}\/20\d{2}$/
       folio_expediente, anio = params[:sesion][:num_tramite].split("/")
       @tramite = Tramite.find(:first, :conditions => ["anio = ? and folio_expediente = ?", anio.to_i, folio_expediente.to_i])
       #@tramite ||= Tramite.create(:folio => folio, :anio => anio, :user_id => current_user.id, :subdireccion_id => current_user.subdireccion_id)
       @sesion.tramite = @tramite if @tramite
    end


#    if params[:sesion][:num_tramite] =~ /^\d{1,4}\/20\d{2}$/
#       folio, anio = params[:sesion][:num_tramite].split("/")
#       @tramite = Tramite.find(:first, :conditions => ["anio = ? and folio = ?", anio.to_i, folio.to_i])
#       @tramite ||= Tramite.create(:folio => folio, :anio => anio, :user_id => current_user.id, :subdireccion_id => current_user.subdireccion_id)
#       @sesion.tramite = @tramite
#    end


    @sesion.fecha = Date.parse(params[:date]) if params[:date]
    @sesion.user = current_user
    #--- guardamos historia de hora y minutos ---
    @sesion.hora = @sesion.horario.hora
    @sesion.minutos = @sesion.horario.minutos
    @sesion.sala_id = @sesion.horario.sala_id
    @sesion.activa = true
    @sesion.generate_clave if @sesion.clave.nil?
     if    @mediador && @comediador && @sesion.save
           ############### REGISTRAMOS AUSENCIA DE ESPECIALISTAS ##################
            @situacion = Situacion.find_by_descripcion("EN SESION")
            @rango_inicial =  5/(24 * 60.0) # 5 Minutos
            @rango_final = 65/(24 * 60.0) # 1 Hora y cinco (65 minutos)
            @fecha_inicio = @sesion.start_at - @rango_inicial
            @fecha_fin = @sesion.start_at + @rango_final
            @autorizo = (current_user) ? current_user.id : session["user_id"]
            if @mediador
               @movimiento_especialista = Movimiento.new
               @movimiento_especialista.update_attributes(:situacion_id => @situacion.id,
                :user_id => @mediador.id, :autorizo => @autorizo, :fecha_inicio => @fecha_inicio,
                :fecha_fin => @fecha_fin, :observaciones => "ESPECIALISTA EN SESION, EXP. #{@sesion.num_tramite}")
               @movimiento_especialista.save
            end
            if @comediador
               @movimiento_comediador = Movimiento.new
               @movimiento_comediador.update_attributes(:situacion_id => @situacion.id,
                :user_id => @comediador.id, :autorizo => @autorizo, :fecha_inicio => @fecha_inicio,
                :fecha_fin => @fecha_fin, :observaciones => "COMEDIADOR EN SESION, EXP. #{@sesion.num_tramite}")
               @movimiento_comediador.save
            end

            #--- Notificaciones ---
            if @sesion.notificacion && @sesion.comediador_id && @sesion.mediador_id
              NotificationsMailer.deliver_sesion_created("mediador", @sesion)
              NotificationsMailer.deliver_sesion_created("comediador", @sesion)
            end
       flash[:notice] = "Sesión guardada correctamente, clave: #{@sesion.clave}"
       redirect_to :action => "daily_show", :controller => "agenda", :day => @sesion.fecha.day, :month=> @sesion.fecha.month, :year => @sesion.fecha.year, :origin => @origin
    else
       flash[:notice] = "no se puedo guardar, verifique"
       @fecha = Date.parse(params[:date])
       @tipos_sesiones = Tiposesion.find(:all, :order => "descripcion")
       @especialistas = User.find_by_sql(["SELECT u.* FROM users u
        inner join roles_users ru on u.id=ru.user_id
        inner join roles r on ru.role_id=r.id
        where r.name='ESPECIALISTAS' and
        u.id not in (select mediador_id from sesions WHERE activa = 1 AND fecha = ? AND hora= ? AND minutos= ?) AND
        u.id not in (select comediador_id from sesions WHERE activa = 1 AND fecha = ? AND hora= ? AND minutos= ?) ORDER BY u.nombre, u.paterno, u.materno", @fecha, @horario.hora, @horario.minutos, @fecha, @horario.hora, @horario.minutos ])
    render :action => "new_with_date"
    end

  end

  def save
    @sesion = (params[:sesion_id]) ? Sesion.find(params[:sesion_id])  :  Sesion.new(params[:sesion])
    @redireccion = params[:sesion_id] ? "list_by_user"  :  "list_by_tramite"
    @sesion.update_attributes(params[:sesion])
    @tramite = Tramite.find(params[:id]) if params[:tramite]
    @sesion.tramite = @tramite unless @sesion.tramite
    @sesion.finished_at ||= Time.now if params[:sesion][:concluida] == "1"
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

  def reprogramar
    unless (@sesion = Sesion.find(params[:id]))
      flash[:notice] = "No se pudo encontrar sesion, verifique"
      redirect_to :controller => "home"
    else
      return render(:partial => 'reprogramar', :layout => "only_jquery")
      @notificacion = (params[:sesion_notificacion]) ? true : false 
    end
  end



  def change_sesion_data
    unless (@sesion = Sesion.find(params[:id]))
      flash[:notice] = "No se pudo encontrar sesion, verifique"
      redirect_to :controller => "home"
    else
      @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
      @notificacion = (params[:sesion_notificacion]) ? true : false 
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
   @notificacion = (params[:sesion_notificacion]) ? true : false 
   @horarios = Horario.find_by_sql(["select * from horarios where id not in (select horario_id as id from sesions where fecha = ?)",  @fecha])
   @title = "Resultados encontrados"
   @horarios_disponibles = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?) and activo=1 group by hora,minutos order by hora,minutos,sala_id", @fecha])
  end


  def show_schedules_with_especialistas
       show_schedules()
       @tiposesion = Tiposesion.find(params[:sesion_tiposesion_id]) if params[:sesion_tiposesion_id]
  end




  def update_schedule
   @sesion= Sesion.find(params[:sesion]) if params[:sesion]
   @mediador = User.find(params[:mediador]) if params[:mediador]
   @comediador = User.find(params[:comediador]) if params[:comediador]
   @horario = Horario.find(params[:horario]) if params[:horario]
   @fecha = Date.parse(params[:fecha]) if params[:fecha]
   @tiposesion = Tiposesion.find(params[:tiposesion]) if params[:tiposesion]
   @sala = @horario.sala ? @horario.sala.id : nil
   @user = current_user ? current_user.id : nil
   flash[:notice] = "No se pudo actualizar correctamente, verifique"
     if @sesion && @horario && @fecha && @mediador && @comediador
        if @sesion.update_attributes!(:horario_id => @horario.id, :hora => @horario.hora, :minutos => @horario.minutos, :fecha => @fecha, :mediador_id => @mediador.id, :comediador_id => @comediador.id, :sala_id => @sala, :user_id => @user)
           #---- Notificamos a especialistas ---
           @sesion.update_attributes!(:tiposesion_id => @tiposesion.id) if @tiposesion
           if params[:notificacion] == "true"
             NotificationsMailer.deliver_sesion_updated("mediador", @sesion)
             NotificationsMailer.deliver_sesion_updated("comediador", @sesion)
           end
           ############ Cambiamos status ##############
           if @sesion.tramite
              (Estatu.find(@sesion.tramite.estatu_id).clave === ("fech-asig")) ?  @sesion.tramite.update_estatus!("camb-sesi", current_user) :  @sesion.tramite.update_estatus!("fech-asig", current_user)
           end
           flash[:notice] = "Hora de sesión actualizada correctamente"
        end
    end
     redirect_to :action => "show", :id => @sesion, :user => current_user.id
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
             #NotificationsMailer.deliver_sesion_canceled("mediador", @sesion)
             #NotificationsMailer.deliver_sesion_canceled("comediador", @sesion)

             ############### BUSCAMOS A ESPECIALISTA Y COMEDIADOR ###############
             if @sesion.num_tramite
              @especialista = Movimiento.find(:first, :conditions => ["user_id = ? AND observaciones like ?", @sesion.mediador_id, "ESPECIALISTA EN SESION, EXP. #{@sesion.num_tramite}%"])
              @comediador = Movimiento.find(:first, :conditions => ["user_id = ? AND observaciones like ?",  @sesion.comediador_id, "COMEDIADOR EN SESION, EXP. #{@sesion.num_tramite}%"])
              @margen =  2/(24 * 60.0)
              @ensesion = Situacion.find_by_descripcion("EN SESION")
              @especialista ||= Movimiento.find(:first, :conditions => ["(? between fecha_inicio AND fecha_fin) AND user_id = ? AND situacion_id = ?", (@sesion.start_at + @margen).strftime("%y-%m-%d %H:%M:%S"), @sesion.mediador_id, @ensesion.id]) if @sesion.start_at
              @comediador ||= Movimiento.find(:first, :conditions => ["(? between fecha_inicio AND fecha_fin) AND user_id = ? AND situacion_id = ?", (@sesion.start_at + @margen).strftime("%y-%m-%d %H:%M:%S"), @sesion.comediador_id, @ensesion.id]) if @sesion.start_at
             end

            #if @sesion.destroy
            if @sesion.cancel?(current_user)
              @especialista.destroy if @especialista
              @comediador.destroy if @comediador
              flash[:notice] = "Sesión cancelada correctamente, notificación enviada a especialistas.."
              return render(:partial => 'sesion_cancelada_mensaje', :layout => 'only_jquery')
              #redirect_to :controller => "home"

            else
              flash[:notice] = "No se pudo cancelar, verifique sesión"
               return render(:partial => 'no_results', :layout => 'only_jquery')
              #redirect_to :action => "show", :id => @sesion
           end
        end
    elsif params[:id]
        flash[:notice] = "Token de seguridad incorrecto"
        redirect_to :action => "show", :id => params[:id]
    else
        redirect_to :controller => "home"
    end
  end


 def enable_form
   if params[:numero_tramite] =~ /^\d{1,4}\/20\d{2}$/
       folio, anio = params[:numero_tramite].split("/")
       @tramite = Tramite.find(:first, :conditions => ["anio = ? and folio = ?", anio.to_i, folio.to_i])     
       @sesiones_activas = (@tramite) ?  Sesion.find(:all, :conditions => ["tramite_id = ? AND concluida = 0", @tramite.id]) : Array.new
       if @tramite && @sesiones_activas.empty?
          @fecha = Date.parse(params[:date])
          @horarios = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?) and activo=1 group by hora,minutos order by hora,minutos,sala_id", @fecha])
          @horario = Horario.find(params[:horario]) if params[:horario]
          @tipos_sesiones = Tiposesion.find(:all, :order => "descripcion")
          #@tramite = (params[:id]) ? Tramite.find(params[:id]) : Tramite.new
          @tramite = Tramite.find(params[:id]) if params[:id]
          @especialistas = User.find_by_sql(["SELECT u.* FROM users u
          inner join roles_users ru on u.id=ru.user_id
          inner join roles r on ru.role_id=r.id
          where r.name='ESPECIALISTAS' and
          u.id not in (select mediador_id from sesions WHERE activa = 1 AND fecha = ? AND hora= ? AND minutos= ?) AND
          u.id not in (select comediador_id from sesions WHERE activa = 1 AND fecha = ? AND hora= ? AND minutos= ?) ORDER BY u.nombre, u.paterno, u.materno", @fecha, @horario.hora, @horario.minutos, @fecha, @horario.hora, @horario.minutos ])
          return render(:partial => 'new_with_date', :layout => false) if request.xhr?
       else
         return render(:partial => 'tramite_not_exists', :layout => false) if request.xhr?
       end
    else
       return render(:partial => 'format_no_valid', :layout => false) if request.xhr?
   end
 end
end
