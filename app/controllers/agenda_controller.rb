class AgendaController < ApplicationController
  require_role [:controlagenda, :especialistas], :for => [:management, :search_sesiones]
 
  def calendario
#     @sesiones = Sesion.find(:all, :conditions => ["start_at is not NULL"], :order => "start_at")
#     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
#     @title = "Calendario General del Centro Estatal de Justicia Alternativa"
#     return render(:partial => 'calendario', :layout => "oficial")
redirect_to :action => "management"
  end

  def management
     @sesion = Sesion.new
     @sesiones = Sesion.find(:all)
     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
     @title = "Control de agenda"
  end

  def search_sesiones
    if params[:sesion]
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
    @horario = Horario.find(params[:horario])
    @fecha = params[:fecha]
    @sesion = Sesion.new
    @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
  end

  def save_sesion
    @sesion = Sesion.new(params[:sesion])
    # --- if tramite exists ---
    folio, anio = params[:sesion][:num_tramite].split("/") if params[:sesion][:num_tramite]
    @tramite = Tramite.find(:first, :conditions => ["anio = ? and folio = ?", anio, folio])
    @sesion.tramite = (@tramite) ? @ŧramite : Tramite.create(:folio => folio, :anio => anio)
    @sesion.horario = Horario.find(params[:horario]) if params[:horario]
    @sesion.fecha = params[:fecha] if params[:fecha]
    @sesion.user = current_user
    if @sesion.save
       @sesion.generate_clave
       flash[:notice] = "Sesión guardada correctamente, clave: #{@sesion.clave}"
       redirect_to :action => "management"
    else
       flash[:notice] = "no se puedo guardar, verifique"
       render :action => "new_sesion"
    end
  end

end
