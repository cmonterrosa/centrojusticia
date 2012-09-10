class AgendaController < ApplicationController
  require_role [:controlagenda, :especialistas], :for => [:management, :search_sesiones]
 
  def calendario
      redirect_to :action => "management"
  end

  def management
     @sesion = Sesion.new
     @sesiones = Sesion.find(:all)
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
    unless params[:horario] =~ /^\d{1,2}$/
      @horario = Horario.find(params[:horario])
      @controlador = (params[:origin] == 'customs') ? 'customs' : 'agenda'
      @fecha = params[:fecha]
      @sesion = Sesion.new
      @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
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
    if @sesion.save
       @sesion.generate_clave
       flash[:notice] = "Sesión guardada correctamente, clave: #{@sesion.clave}"
       redirect_to :action => "management", :controller => @controlador
    else
       flash[:notice] = "no se puedo guardar, verifique"
       render :action => "new_sesion"
    end
  end

end
