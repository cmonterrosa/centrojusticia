#!/bin/env ruby
# encoding: utf-8
require 'rubygems'
require 'gruff'
require 'fastercsv'

class EstadisticasController < ApplicationController
  layout :set_layout

  require_role [:admin, :direccion, :subdireccion, :bitacora, :admindireccion]
  

     def index

     end

    def select_grafica_noatencion
     @title = "Seleccione el rango de fechas para estadística de no atención"
     @action = "grafica_noatencion"
     return render(:partial => 'select_date_range', :layout => 'only_jquery')
    end

    def select_grafica_materia
     @title = "Seleccione el rango de fechas para estadística por materia"
     @action = "grafica_materia"
     return render(:partial => 'select_date_range', :layout => 'only_jquery')
    end

    def select_grafica_orientaciones_especialistas
     @title = "Seleccione el rango de fechas para estadística de atención de especialistas"
     @action = "grafica_orientaciones_especialistas"
     return render(:partial => 'select_date_range', :layout => 'only_jquery')
    end

    def select_estadisticas_generales
      @title = "Seleccione el rango de fechas para generar estadística general"
      @action = "estadisticas_generales"
      return render(:partial => 'select_date_range', :layout => 'kolaval')
    end

    def estadisticas_generales
          if params[:fecha_inicio] && params[:fecha_fin]
             calculo_estadisticas_generales
             return render(:partial => 'estadisticas_generales', :layout => 'kolaval')
          end
    end


    def estadisticas_generales_pdf
           if params[:fecha_inicio] && params[:fecha_fin]
              calculo_estadisticas_generales
              return render(:partial => 'estadisticas_generales_pdf', :layout => 'pdf')
          end
    end


    def calculo_estadisticas_generales
             params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
             @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
             @estatus = Estatu.find(:all, :conditions => ["clave not in ('tram-inic')"], :order => "descripcion")
             ## Procedencias de atenciones extraordinarfias
             @procedencias = Procedencia.find_by_sql ["select p.descripcion, count(extraordinarias.id) as numero_atenciones from extraordinarias extraordinarias inner join procedencias p  on extraordinarias.procedencia_id=p.id where (extraordinarias.fechahora between ? AND ?) group by p.descripcion", @inicio, @fin]
             @orientaciones_hombres = Orientacion.count(:sexo, :joins => "orientacions, tramites t, estatus e", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in ('comp-conc', 'no-compar') AND (orientacions.fechahora between ? AND ?) AND orientacions.sexo = ?", @inicio, @fin, 'M'])
             @orientaciones_mujeres = Orientacion.count(:sexo, :joins => "orientacions, tramites t, estatus e", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in ('comp-conc', 'no-compar') AND (orientacions.fechahora between ? AND ?) AND orientacions.sexo = ?", @inicio, @fin, 'F'])
             @comparecencias_concluidas = Orientacion.count(:tramite_id, :joins => "orientacions, tramites t, estatus e", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in ('comp-conc') AND (orientacions.fechahora between ? AND ?)", @inicio, @fin])
             @materia_asignada = Orientacion.count(:tramite_id, :joins => "orientacions, tramites t, estatus e", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in ('mate-asig') AND (orientacions.fechahora between ? AND ?)", @inicio, @fin])
             @solo_orientacion = Orientacion.count(:tramite_id, :joins => "orientacions, tramites t, estatus e", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in ('no-compar') AND (orientacions.fechahora between ? AND ?)", @inicio, @fin])
             ### Contabilizamos materia ####
             @detalle_materias = Array.new
             @materias = Materia.find(:all, :order => "descripcion")
             @total_materias = Tramite.count(:materia_id, :conditions => ["folio_expediente IS NOT NULL AND materia_id IS NOT NULL AND (fechahora between ? AND ?)",  @inicio, @fin])
             @materias.each do |materia|
              total = Tramite.count(:materia_id, :conditions => ["folio_expediente IS NOT NULL AND materia_id = ? AND (fechahora between ? AND ?)", materia.id, @inicio, @fin])
                if total > 0
                  @detalle_materias << {"nombre" => "#{materia.descripcion}", "total" => total}
                end
              end

             @total_expedientes_generados = Tramite.count(:id, :conditions => ["folio_expediente IS NOT NULL and fechahora between ? AND ?", @inicio, @fin])
             @total_orientaciones = @comparecencias_concluidas + @solo_orientacion
             @atenciones_extraordinarias = Extraordinaria.count(:id, :conditions => ["fechahora between ? AND ?", @inicio, @fin])
             especialistas = User.find_by_sql("select u.* from users u inner join roles_users ru on u.id=ru.user_id inner join roles r on ru.role_id=r.id Where r.name = 'especialistas' order by u.login")
             @comparecencias_conocimiento = Orientacion.count(:tramite_id, :joins => "orientacions, tramites t, estatus e, comparecencias c", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND t.id = c.tramite_id AND e.clave in ('comp-conc') AND (c.conocimiento = ? ) AND (c.fechahora between ? AND ?)", true, @inicio, @fin])
             @comparecencias_noconocimiento = Orientacion.count(:tramite_id, :joins => "orientacions, tramites t, estatus e, comparecencias c", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND t.id = c.tramite_id AND e.clave in ('comp-conc') AND (c.conocimiento = ? ) AND (c.fechahora between ? AND ?)", false, @inicio, @fin])
             @especialistas = especialistas.sort{|p1,p2| p1.num_orientaciones_periodo(@inicio,@fin) <=> p2.num_orientaciones_periodo(@inicio,@fin)}
             @participantes_hombres = Orientacion.count(:tramite_id, :joins => "orientacions, tramites t, estatus e, comparecencias c, participantes p", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND t.id = c.tramite_id AND c.id = p.comparecencia_id AND e.clave in ('comp-conc', 'mate-asig', 'fech-asig') AND (p.sexo = ? ) AND (c.fechahora between ? AND ?)", "M", @inicio, @fin])
             @participantes_mujeres = Orientacion.count(:tramite_id, :joins => "orientacions, tramites t, estatus e, comparecencias c, participantes p", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND t.id = c.tramite_id AND c.id = p.comparecencia_id AND e.clave in ('comp-conc', 'mate-asig', 'fech-asig') AND (p.sexo = ? ) AND (c.fechahora between ? AND ?)", "F", @inicio, @fin])
             @personas_morales = Orientacion.count(:tramite_id, :joins => "orientacions, tramites t, estatus e, comparecencias c, participantes p, tipopersonas tp", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND t.id = c.tramite_id AND c.id = p.comparecencia_id AND p.tipopersona_id = tp.id AND e.clave in ('comp-conc', 'mate-asig', 'fech-asig') AND (tp.descripcion = ? ) AND (c.fechahora between ? AND ?)", "MORAL", @inicio, @fin])
    end

#--- Inicia gráfica de orientaciones ----
  def grafica_orientaciones_especialistas_old
      g = Gruff::Pie.new
      #g = Gruff::Bar.new
      g.title = "Orientaciones"
      @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
      if params[:fecha_inicio] && params[:fecha_fin]
          params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
          @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
          g.title = "Orientaciones del #{@inicio.strftime('%d/%m')} al #{@fin.strftime('%d/%m')}"
          @especialistas.each do |especialista|
            total_sesiones = Orientacion.count(:id, :conditions => ["user_id = ? AND fechahora between ? AND ? ", especialista.id.to_i, @inicio, @fin])
              if total_sesiones > 0
                g.data("#{especialista.nombre}", [total_sesiones])
              end
            end
      else
            g.title = "Total de orientaciones"
            @especialistas.each do |especialista|
            total_sesiones = Orientacion.count(:id, :conditions => ["user_id = ?", especialista.id.to_i])
              if total_sesiones > 0
                g.data("#{especialista.nombre}", [total_sesiones])
              end
            end
      end
     g.labels = {0=>'Número por especialista'}
    send_data(g.to_blob,:disposition => 'inline', :type => 'image/png', :filename => "list.png")
  end

 def grafica_orientaciones_especialistas
      g = Gruff::Bar.new
      g.title = "Orientaciones"
      g.no_data_message = "No existe información"
      g.add_color("#E00CF7")
      g.add_color("#1BFB02") # Verde Fuerte
      g.add_color("#B3FF00")
      g.add_color("#0037FF")
      g.add_color("#2CF8EE")
      g.add_color("#EABFFE") # Moradito claro
      g.add_color("#F5F83C") #Amarillo
      g.add_color("#FD24A3") #Rosa Mexicano
      g.add_color("#FD242F") # Rojo
      g.add_color("#AFD2FE") # Celeste
      g.add_color("#C1F7BB") # verde Pistache
      g.additional_line_values
      g.has_left_labels
      especialistas = Role.find_by_name("especialistas").todos_usuarios
      if params[:fecha_inicio] && params[:fecha_fin]
          params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
          @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
          g.title = "Orientaciones y/o comparecencias"
          #@especialistas = especialistas.sort{|p1,p2| p1.num_orientaciones_periodo(@inicio,@fin) <=> p2.num_orientaciones_periodo(@inicio,@fin)}
          especialistas.each do |especialista|
                g.data("#{especialista.nombre}(#{especialista.num_orientaciones_periodo(@inicio,@fin)})", [especialista.num_orientaciones_periodo(@inicio,@fin)]) if especialista.num_orientaciones_periodo(@inicio,@fin) > 0
          end
      else
            especialistas.each do |especialista|
            total_sesiones = Orientacion.count(:id, :conditions => ["user_id = ?", especialista.id.to_i])
              if total_sesiones > 0
                g.data("#{especialista.nombre}", [total_sesiones], '#ffcc00')
              end
            end
      end
      g.sort
      g.x_axis_label = "Período del #{@inicio.strftime('%d de %B de %Y')} al #{@fin.strftime('%d de %B de %Y')} "
      send_data(g.to_blob,:disposition => 'inline', :type => 'image/png', :filename => "list.png")
 end


 def grafica_noatencion
 g = Gruff::Bar.new
      g.title = "Orientaciones"
      g.no_data_message = "No existe información"
      g.add_color("#E00CF7")
      g.add_color("#1BFB02") # Verde Fuerte
      g.add_color("#B3FF00")
      g.add_color("#0037FF")
      g.add_color("#2CF8EE")
      g.add_color("#EABFFE") # Moradito claro
      g.add_color("#F5F83C") #Amarillo
      g.add_color("#FD24A3") #Rosa Mexicano
      g.add_color("#FD242F") # Rojo
      g.add_color("#AFD2FE") # Celeste
      g.add_color("#C1F7BB") # verde Pistache
      g.x_axis_label = "No atencion"
      
    if params[:fecha_inicio] && params[:fecha_fin]
       params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
       @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
    end
    if @inicio && @fin
       especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
       @tramites = Tramite.find(:all, :conditions => ["created_at between ? AND ?", @inicio, @fin])
       @justificacion = Justificacion.find_by_descripcion("ESPECIALISTA NO DA ATENCIÓN")
       g.title = "Total de no atenciones"
            especialistas.each do |especialista|
            total_noatenciones = Historia.count(:especialista_id, :conditions => ["tramite_id in (?) AND justificacion_id = ? AND especialista_id = ?", @tramites.map{|t|t.id}, @justificacion.id, especialista.id.to_i])
              if total_noatenciones > 0
                g.data("#{especialista.nombre}", [total_noatenciones])
              end
            end
      #@historias = Historia.find(:all, :conditions => ["tramite_id in (?) AND justificacion_id = ? AND especialista_id IS NOT NULL", @tramites.map{|t|t.id}, @justificacion.id ])
    else
      flash[:error] = "Parámetros insuficientes, verifique"
      redirect_to :action => "atenciones_no_brindadas"
    end
      g.sort
      send_data(g.to_blob,:disposition => 'inline', :type => 'image/png', :filename => "list.png")
end


  def select_grafica_sesiones_especialistas
     @title = "Seleccione el rango de fechas"
     @action = "grafica_orientaciones_especialistas"
     return render(:partial => 'select_date_range', :layout => 'only_jquery')
  end


  def grafica_sesiones_especialistas
      #g = Gruff::Pie.new
      g = Gruff::Bar.new
      g.title = "Sesiones por especialista del "
      @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
      if params[:fecha_inicio] && params[:fecha_fin]
          params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
          @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
          g.title = "Sesiones por especialista del #{@inicio.strftime('%d')} al #{@fin.strftime('%d de %m')}"
          @especialistas.each do |especialista|
            total_sesiones = Sesion.count(:id, :conditions => ["mediador_id = ? AND activa=true AND fecha between ? AND ? ", especialista.id.to_i, @inicio, @fin])
              if total_sesiones > 0
                g.data("#{especialista.nombre}", [total_sesiones])
              end
            end
      else
             g.title = "Sesiones por especialistas"
            @especialistas.each do |especialista|
            total_sesiones = Sesion.count(:id, :conditions => ["mediador_id = ? AND activa=true", especialista.id.to_i])
              if total_sesiones > 0
                g.data("#{especialista.nombre}", [total_sesiones])
              end
            end
      end
    send_data(g.to_blob,:disposition => 'inline', :type => 'image/png', :filename => "list.png")
  end


  def grafica_atencion_rango_edad
      #g = Gruff::Pie.new
      g = Gruff::Bar.new
      g.title = "Atención por rango de edades"
      
      # --- Rango de edades ---
      # (1-15) (16-30) (31-45) (46-60) (Más de 60)

      @total = Participante.count(:id, :conditions => "comparecencia_id is NOT NULL") * 1.0

      @today = Time.now
      @sum_1_15 = Participante.count(:fecha_nac, :conditions => ["fecha_nac < ? AND fecha_nac >= ?", @today, @today.years_ago(15)])

      @sum_16_30 = Participante.count(:fecha_nac, :conditions => ["fecha_nac < ? AND fecha_nac >= ?", @today.years_ago(15), @today.years_ago(30)])
      @sum_31_45 = Participante.count(:fecha_nac, :conditions => ["fecha_nac < ? AND fecha_nac >= ?", @today.years_ago(30), @today.years_ago(45)])
      @sum_46_60 = Participante.count(:fecha_nac, :conditions => ["fecha_nac < ? AND fecha_nac >= ?", @today.years_ago(45), @today.years_ago(60)])
      @sum_60_mas = Participante.count(:fecha_nac, :conditions => ["fecha_nac < ?", @today.years_ago(60)])

      # --- Datos --
      g.data("de 16 a 30 (#{"%0.2f" %((@sum_1_15.to_i + @sum_16_30.to_i) / @total * 100.0)})%", [ @sum_1_15 + @sum_16_30 ])
      g.data("de 31 a 45 (#{"%0.2f" %((@sum_16_30.to_i) / @total * 100.0) })%", [ @sum_31_45])
      g.data("de 46 a 60 (#{"%0.2f" %((@sum_31_45.to_i) / @total * 100.0)})%", [ @sum_46_60])
      g.data("más de 60 (#{"%0.2f" %((@sum_60_mas.to_i) / @total * 100.0) })%", [ @sum_60_mas])
      send_data(g.to_blob,:disposition => 'inline', :type => 'image/png', :filename => "list.png")
   end


    def grafica_atencion_sexo
      g = Gruff::Pie.new
      #g = Gruff::Bar.new
      g.title = "Orientaciones por sexo"
      @male = Orientacion.count(:sexo, :conditions => ["sexo = 'M'"])
      @female = Orientacion.count(:sexo, :conditions => ["sexo = 'F'"])
      g.data("HOMBRES", [@male])
      g.data("MUJERES", [@female])
      g.labels = {0=>'Número de orientaciones'}
      send_data(g.to_blob,:disposition => 'inline', :type => 'image/png', :filename => "list.png")
  end

  def grafica_materia
      #g = Gruff::Pie.new
      g = Gruff::Bar.new
      if params[:fecha_inicio] && params[:fecha_fin]
          params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
          @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
           g.title = "ASUNTOS POR MATERIA"
           g.x_axis_label = "Período del #{@inicio.strftime('%d de %B de %Y')} al #{@fin.strftime('%d de %B de %Y')} "
           g.no_data_message = "No existe información"
      end

      g.add_color("#E00CF7")
      g.add_color("#1BFB02") # Verde Fuerte
      g.add_color("#B3FF00")
      g.add_color("#0037FF")
      g.additional_line_values
      g.has_left_labels
      total_asuntos = Tramite.count(:id, :joins => "tramites, comparecencias c", :conditions => ["tramites.id=c.tramite_id AND tramites.folio_expediente IS NOT NULL AND tramites.materia_id IS NOT NULL AND tramites.fechahora between ? and ?", @inicio, @fin ])
      #   g.x_axis_label = "TOTAL DEL AÑO 2013: #{total_asuntos} ASUNTOS"
      @materias = Materia.find(:all, :order => "descripcion")
      @materias.each do |materia|
        #g.data("#{materia.descripcion}", [Tramite.count(:id, :conditions => ["materia_id = ?", materia.id])])
        total = Tramite.count(:id, :conditions => ["folio_expediente IS NOT NULL AND materia_id = ? and fechahora between ? AND ?", materia.id, @inicio, @fin])
        if total > 0
              g.data("#{materia.descripcion} (#{total}) - #{"%0.2f" % ((total / (total_asuntos * 1.0)) * 100.0)}%", [total])
        end

      end
       #g.data("SIN ASIGNAR (#{Temporal.count(:id, :conditions => 'materia_id is NULL')}) - #{"%0.2f" % ((Temporal.count(:id, :conditions => 'materia_id is NULL') / (total_asuntos * 1.0)) * 100.0)}%")
      send_data(g.to_blob,:disposition => 'inline', :type => 'image/png', :filename => "list_by_materia.png")
  end


  def select_personas_atendidas
   
  end

  def search_personas_atendidas
    params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
    @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
    #@tramites = Tramite.find(:all, :conditions => ["created_at between ? AND ?",@inicio, @fin], :order => "created_at")
     @tramites = Tramite.find(:all, 
                              :select => "tramites.*",
                              :joins => "tramites, orientacions orientacions, estatus e",
                              :conditions => ["orientacions.tramite_id=tramites.id AND tramites.estatu_id=e.id AND e.clave in ('comp-conc', 'no-compar', 'tram-escr', 'mate-asig', 'fecha-asig', 'camb-sesi', 'tram-conc') AND (orientacions.fechahora between ? AND ?)", @inicio, @fin],
                              :order => ["tramites.fechahora DESC, tramites.folio_expediente"])

      #@tramites = @tramites.sort{|a,b|  a.numero_expediente <=> b.numero_expediente}
      @tramites = @tramites.paginate(:page => params[:page], :per_page => 25)
  end

  
  ###### DESCARGA DE BITACORA ######

  def download_bitacora
    params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
    @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
    @tramites = Tramite.find(:all,
                              :select => "tramites.*",
                              :joins => "tramites, orientacions orientacions, estatus e",
                              :conditions => ["orientacions.tramite_id=tramites.id AND tramites.estatu_id=e.id AND e.clave in  ('comp-conc', 'no-compar', 'tram-escr', 'mate-asig', 'fecha-asig', 'camb-sesi', 'tram-conc')  AND (orientacions.fechahora between ? AND ?)", @inicio, @fin],
                               :order => ["tramites.fechahora DESC, tramites.folio_expediente"])
    
    csv_string = FasterCSV.generate(:encoding => 'u') do |csv|
      csv << ["NP", "NUMERO_TRAMITE", "ESTATUS_DEL TRAMITE",  "NUMERO_EXPEDIENTE",  "ESPECIALISTA_BRINDO_ORIENTACION",   "CATEGORIA",  "FECHA_HORA",  "SOLICITANTES", "INVOLUCRADOS"]
      np=1
      @tramites.each do |t|
         especialista = (t.orientacion.especialista) ? t.orientacion.especialista.nombre_completo : "POR ESCRITO"
         categoria = (t.orientacion.especialista) ? t.orientacion.especialista.categoria : "-----"
          comparecencia = Comparecencia.find(:first, :conditions => ["tramite_id = ?", t.id])
          solicitantes = (comparecencia) ? comparecencia.solicitantes : "-----"
          involucrados = (comparecencia) ? comparecencia.involucrados : "-----"
          fecha_hora = t.fechahora.strftime("%d de %B de %Y - %H:%M:%S")
         csv << [ np, t.folio_integrado, t.estatus, t.numero_expediente,  especialista, categoria, fecha_hora, solicitantes, involucrados]
         np+=1 
      end
    end
  send_data csv_string, type => "text/plain",
    :filename => "bitacora_#{Time.now.strftime("%d-%m-%Y_%I%M_%p")}.csv",
    :disposition => "attachment"
  end

  def show_cargas_trabajo
    @todos_especialistas = Role.find_by_name("ESPECIALISTAS").todos_usuarios
    @todos_especialistas.each do |e| e["puntuacion_final"] = e.puntuacion_general end
    @especialistas_semana = (@todos_especialistas.sort{|p1,p2| p1["puntuacion_final"] <=> p2["puntuacion_final"]}).reverse
    return render(:partial => 'show_cargas_trabajo', :layout => 'only_jquery')
  end

  def select_bitacora_ausencias_personal
     @title = "Listado de trabajadores ausentes"
     @action = "show_ausencias"
     @situaciones = Situacion.find(:all, :conditions => ["descripcion not in (?)", "disponible"])
     @situaciones << Situacion.new(:descripcion => "TODOS LOS MOTIVOS")
     return render(:partial => 'select_date_range_ausencias', :layout => 'oficial')
  end

  def show_ausencias
     if params[:fecha_inicio] && params[:fecha_fin]
          params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
          @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
          @situacion = Situacion.find(params[:situacion]) if params[:situacion] && params[:situacion].size > 0
          @movimientos = (@situacion) ? Movimiento.find(:all, :conditions => ["situacion_id = ? AND ((fecha_inicio between ? AND ?) OR (fecha_fin between ? AND ?))", @situacion, @inicio, @fin, @inicio, @fin], :order => "fecha_inicio,fecha_fin") : Movimiento.find(:all, :conditions => ["(fecha_inicio between ? AND ?) OR (fecha_fin between ? AND ?)", @inicio, @fin, @inicio, @fin], :order => "fecha_inicio,fecha_fin")
          #--- Variables for show bar ----
          @situaciones = Situacion.find(:all, :conditions => ["descripcion not in (?)", "disponible"])
          @situaciones << Situacion.new(:descripcion => "TODOS LOS MOTIVOS")
          @title = "Listado de trabajadores ausentes"
          @action = "show_ausencias"
          return render(:partial => 'show_ausencias', :layout => 'oficial')
     end
  end

    ### REPORTE DE ORIENTACIONES CONCURRENTES CON SESIONES #####

  def reporte_orientaciones_concurrentes
   @orientaciones = Orientacion.find(:all, :order => "fechahora DESC")
   @recurrentes = Array.new
   total_minutos_anticipacion=10
   @tiempo_actual = DateTime.civil(Time.now.year, Time.now.month, Time.now.day, Time.now.hour, Time.now.strftime('%M').to_i)
   @orientaciones.each do |o|
       @fechahora_de_orientacion = DateTime.civil(o.fechahora.year, o.fechahora.month, o.fechahora.day, o.fechahora.hour, o.fechahora.strftime('%M').to_i) if o.fechahora
        @sesiones_del_mismo_dia = Sesion.find(:all, :select => "id, hora, minutos, horario_id, sala_id, fecha", :conditions => ["(cancel IS NULL or cancel=0) AND fecha= ? AND (mediador_id = ? OR comediador_id = ?)", @fechahora_de_orientacion.strftime("%Y-%m-%d"), o.especialista_id, o.especialista_id])
         @sesiones_del_mismo_dia.each do |s|
            if ((s.start_at - ((total_minutos_anticipacion/60.0)/(24.0))) <= @fechahora_de_orientacion) && (@fechahora_de_orientacion <= (s.start_at - ((1/60.0)/(24.0))))
                  @recurrentes << ("Especialista: #{o.especialista.nombre_completo} / Sesion recurrente a orientacion: #{s.start_at.strftime('%d/%m/%Y - %H:%M:%S')} y Orientacion a: #{@fechahora_de_orientacion.strftime('%d/%m/%Y - %H:%M:%S')}")
            end
         end
     end
     
  end


  def set_layout
    (action_name == 'estadisticas_generales_pdf')? 'pdf' : 'kolaval'
  end



end
