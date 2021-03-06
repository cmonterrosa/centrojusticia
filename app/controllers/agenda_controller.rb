class AgendaController < ApplicationController
  layout 'oficial_fancy'
  #require_role [:controlagenda, :admindireccion], :for => [:new_sesion]
  #require_role [:controlagenda, :especialistas, :lecturaagenda, :admindireccion], :for => [:management, :search_sesiones, :calendario]
  require_role [:controlagenda, :lecturaagenda, :especialistas, :admindireccion, :direccion]



  def calendario
      redirect_to :action => "management"
  end

  def management
     @sesion = Sesion.new
     @sesiones = Sesion.find(:all, :select=> ["s.*"], :joins => "s, horarios h", :conditions => ["s.horario_id=h.id"], :order => "s.fecha, h.hora,h.minutos")
     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
     @title = "Control de agenda"
  end

  def search_sesiones
    if params[:sesion]  && params[:sesion][:fecha] =~ /^\d{4}\/\d{1,2}\/\d{1,2}$/
      @fecha = params[:sesion][:fecha] if params[:sesion][:fecha]
      @horarios = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?)",  DateTime.parse(@fecha)])
      @sesiones = Sesion.find(:all)
      @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
      @title = "Resultados encontrados"
      @horarios_disponibles = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?) and activo=1 group by hora,minutos order by hora,minutos,sala_id", DateTime.parse(@fecha)])
      @salas = Sala.find(:all, :order => "descripcion")
    else
      redirect_to :action => "management"
    end
  end

  def new_sesion
    if params[:horario] =~ /^\d{1,3}$/
      @horario = Horario.find(params[:horario])
      @controlador = (params[:origin] == 'customs') ? 'customs' : 'agenda'
      @fecha = params[:fecha]
      @sesion = Sesion.new
      #@especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
      @especialistas = User.find_by_sql(["SELECT u.* FROM users u
    inner join roles_users ru on u.id=ru.user_id
    inner join roles r on ru.role_id=r.id
    where r.name='ESPECIALISTAS' and
    u.id not in (select mediador_id from sesions WHERE fecha = ? and hora= ? and minutos= ?)", @fecha, @horario.hora, @horario.minutos ])
    

    else
      flash[:notice] = "Seleccione un horario, verifique los datos"
      redirect_to :controller => @controlador, :action => "search_sesiones"
    end
  end

  def save_sesion
    @sesion = Sesion.new(params[:sesion])
    @controlador = (params[:origin] == 'customs') ? 'customs' : 'agenda'
    # --- if tramite exists ---
    folio, anio = params[:sesion][:num_tramite].split("/") if params[:sesion][:num_tramite]
    @tramite = Tramite.find(:first, :conditions => ["anio = ? and folio = ?", anio, folio])
    @sesion.tramite = (@tramite) ? @ŧramite : Tramite.create(:folio => folio, :anio => anio, :user_id => current_user.id, :subdireccion_id => current_user.subdireccion_id)
    @sesion.horario = Horario.find(params[:horario]) if params[:horario]
    @sesion.fecha = params[:fecha] if params[:fecha]
    @sesion.user = current_user
    #--- guardamos historia de hora y minutos ---
    @sesion.hora = @sesion.horario.hora
    @sesion.minutos = @sesion.horario.minutos
    @sesion.sala_id = @sesion.horario.sala_id
    @sesion.activa = true
    if @sesion.save
       @sesion.generate_clave
       flash[:notice] = "Sesión guardada correctamente, clave: #{@sesion.clave}"
       redirect_to :action => "management", :controller => @controlador
    else
       flash[:notice] = "no se puedo guardar, verifique"
       render :action => "new_sesion"
    end
  end

  def daily_select
    
  end

  def daily_show
    @origin=params[:origin] if params[:origin]
    @type = params[:type] if params[:type]
    if params[:year] =~ /^\d{4}$/ && params[:month] =~ /^\d{1,2}$/ && params[:day] =~ /^\d{1,2}$/
       @fecha = DateTime.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
       @before = @fecha.yesterday
       @after = @fecha.tomorrow
       @salas = Sala.find(:all, :order => "descripcion")
       @horarios = Horario.find(:all, :group => "hora,minutos")
    else
      redirect_to :action => @accion
    end
  end

  def update_daily_show
       if params[:fecha]
          @fecha = DateTime.parse(params[:fecha])
          @before = @fecha.yesterday
          @after = @fecha.tomorrow
          @salas = Sala.find(:all, :order => "descripcion")
          @horarios = Horario.find(:all, :group => "hora,minutos")
          return render(:partial => 'dynamic_daily_show', :layout => 'only_jquery')
       else
          render :text => "Ocurrió un error, vuelva a cargar la página"
       end
  end

end
