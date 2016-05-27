#!/bin/env ruby
# encoding: utf-8
class AgendaController < ApplicationController
  layout :set_layout
  #require_role [:controlagenda, :admindireccion], :for => [:new_sesion]
  #require_role [:controlagenda, :especialistas, :lecturaagenda, :admindireccion], :for => [:management, :search_sesiones, :calendario]
  require_role [:controlagenda, :lecturaagenda, :especialistas, :admindireccion, :direccion, :asignahorario]



  def calendario
      redirect_to :action => "management"
  end

  def management
     @sesion = Sesion.new
     #@sesiones = Sesion.find(:all, :select=> ["s.*"], :joins => "s, horarios h", :conditions => ["s.horario_id=h.id"], :order => "s.fecha, h.hora,h.minutos")
     #@sesiones = Sesion.find_by_sql("select s.id, s.horario_id, s.fecha from sesions s inner join horarios h  on s.horario_id=h.id LIMIT 80")
     #@sesiones =  Sesion.find(:all, :select=> ["s.*"], :joins => "s, horarios h", :conditions => ["(cancel is NULL OR cancel=0) AND s.horario_id=h.id"], :order => "s.fecha, h.hora,h.minutos")
      @sesiones = []
     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
     @title = "CONTROL DE AGENDA"
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
      flash[:error] = "Seleccione un horario, verifique los datos"
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
       flash[:error] = "no se pudo guardar, verifique"
       render :action => "new_sesion"
    end
  end

  def daily_select
    
  end

  def daily_show
    @origin=params[:origin] if params[:origin]
    @type = params[:type] if params[:type]
    @token = params[:token] if params[:token]
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

  #### IMPRESION DE AGENDA EN FORMATO PDF ####

  def menu_impresion
    @origin=params[:origin] if params[:origin]
    @type = params[:type] if params[:type]
    @titulo = (@type == 'custom') ? "Agenda de Sesiones para #{current_user.nombre_completo}" : "Agenda de Sesiones General"
    @impreso_por = (current_user) ? "| Impreso por : #{current_user.nombre_completo}" : ""
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

  def daily_show_pdf
    @origin=params[:origin] if params[:origin]
    @type = params[:type] if params[:type]
    @tipos_sesiones = Tiposesion.find(params[:tipos][:sesiones])  if params[:tipos] && params[:tipos][:sesiones]
    @titulo = (@type == 'custom') ? "Agenda de Sesiones para #{current_user.nombre_completo}" : "Agenda de Sesiones General"
    @impreso_por = (current_user) ? "| Impreso por : #{current_user.nombre_completo}" : ""
    unless (@tipos_sesiones.nil? || @tipos_sesiones.empty?)
       if  params[:year] =~ /^\d{4}$/ && params[:month] =~ /^\d{1,2}$/ && params[:day] =~ /^\d{1,2}$/
          @fecha = DateTime.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
          @before = @fecha.yesterday
          @after = @fecha.tomorrow
          @salas = Sala.find(:all, :order => "descripcion")
          @horarios = Horario.find(:all, :group => "hora,minutos")
      else
          flash[:notice] = "verifique las fechas estén correctas"
          redirect_to :action => @accion
      end
    else
      flash[:warning] = "Seleccione al menos un tipo de sesión"
      redirect_to(:back)
      #redirect_to(:action => "daily_show", :origin => @origin, :type => @type, :year => params[:year], :month => params[:month], :day => params[:day])
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

   def set_layout
    (action_name == 'daily_show_pdf')? 'pdf' : 'kolaval'
  end

end
