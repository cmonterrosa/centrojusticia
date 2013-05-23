require 'rubygems'
require 'gruff'
class EstadisticasController < ApplicationController
  layout 'oficial_fancy'

     def index

     end

    def select_grafica_orientaciones_especialistas
     @title = "Seleccione el rango de fechas"
     @action = "grafica_orientaciones_especialistas"
     return render(:partial => 'select_date_range', :layout => 'only_jquery')
    end

    def select_estadisticas_generales
      @title = "Seleccione el rango de fechas"
      @action = "estadisticas_generales"
      return render(:partial => 'select_date_range', :layout => 'only_jquery')
    end

    def estadisticas_generales
          if params[:fecha_inicio] && params[:fecha_fin]
             params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
             @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
             ### anterior
             #@total_orientaciones = Orientacion.count(:id, :conditions => ["fechahora between ? AND ?", @inicio, @fin])
             #@orientaciones_hombres = Orientacion.count(:sexo, :conditions => ["sexo = ? AND fechahora between ? AND ?", 'M', @inicio, @fin])
             #@orientaciones_mujeres = Orientacion.count(:sexo, :conditions => ["sexo = ? AND fechahora between ? AND ?", 'F', @inicio, @fin])



             @orientaciones_hombres = Orientacion.count(:sexo, :joins => "orientacions, tramites t, estatus e", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in ('comp-conc', 'no-compar') AND (orientacions.fechahora between ? AND ?) AND orientacions.sexo = ?", @inicio, @fin, 'M'])
             @orientaciones_mujeres = Orientacion.count(:sexo, :joins => "orientacions, tramites t, estatus e", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in ('comp-conc', 'no-compar') AND (orientacions.fechahora between ? AND ?) AND orientacions.sexo = ?", @inicio, @fin, 'F'])
             @comparecencias_concluidas = Orientacion.count(:tramite_id, :joins => "orientacions, tramites t, estatus e", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in ('comp-conc') AND (orientacions.fechahora between ? AND ?)", @inicio, @fin])
             @solo_orientacion = Orientacion.count(:tramite_id, :joins => "orientacions, tramites t, estatus e", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in ('no-compar') AND (orientacions.fechahora between ? AND ?)", @inicio, @fin])

             @total_orientaciones = @comparecencias_concluidas + @solo_orientacion
             @atenciones_extraordinarias = Extraordinaria.count(:id, :conditions => ["fechahora between ? AND ?", @inicio, @fin])

             especialistas = User.find_by_sql("select u.* from users u inner join roles_users ru on u.id=ru.user_id inner join roles r on ru.role_id=r.id Where r.name = 'especialistas' order by u.login")
             @comparecencias_conocimiento = Orientacion.count(:tramite_id, :joins => "orientacions, tramites t, estatus e, comparecencias c", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND t.id = c.tramite_id AND e.clave in ('comp-conc') AND (c.conocimiento = ? ) AND (c.fechahora between ? AND ?)", true, @inicio, @fin])
             @comparecencias_noconocimiento = Orientacion.count(:tramite_id, :joins => "orientacions, tramites t, estatus e, comparecencias c", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND t.id = c.tramite_id AND e.clave in ('comp-conc') AND (c.conocimiento = ? ) AND (c.fechahora between ? AND ?)", false, @inicio, @fin])
             @especialistas = especialistas.sort{|p1,p2| p1.num_orientaciones_periodo(@inicio,@fin) <=> p2.num_orientaciones_periodo(@inicio,@fin)}
             #@especialista_mas_activo = @especialistas.last.nombre_completo
             #@especialista_menos_activo = @especialistas.first.nombre_completo
             @participantes_hombres = Orientacion.count(:tramite_id, :joins => "orientacions, tramites t, estatus e, comparecencias c, participantes p", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND t.id = c.tramite_id AND c.id = p.comparecencia_id AND e.clave in ('comp-conc') AND (p.sexo = ? ) AND (c.fechahora between ? AND ?)", "M", @inicio, @fin])
             @participantes_mujeres = Orientacion.count(:tramite_id, :joins => "orientacions, tramites t, estatus e, comparecencias c, participantes p", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND t.id = c.tramite_id AND c.id = p.comparecencia_id AND e.clave in ('comp-conc') AND (p.sexo = ? ) AND (c.fechahora between ? AND ?)", "F", @inicio, @fin])
             @personas_morales = Orientacion.count(:tramite_id, :joins => "orientacions, tramites t, estatus e, comparecencias c, participantes p, tipopersonas tp", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND t.id = c.tramite_id AND c.id = p.comparecencia_id AND p.tipopersona_id = tp.id AND e.clave in ('comp-conc') AND (tp.descripcion = ? ) AND (c.fechahora between ? AND ?)", "MORAL", @inicio, @fin])
             return render(:partial => 'estadisticas_generales', :layout => 'only_jquery')
          end
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
      especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
      if params[:fecha_inicio] && params[:fecha_fin]
          params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
          @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
          g.title = "Orientaciones del #{@inicio.strftime('%d/%m')} al #{@fin.strftime('%d/%m')}"
          #@especialistas = especialistas.sort{|p1,p2| p1.num_orientaciones_periodo(@inicio,@fin) <=> p2.num_orientaciones_periodo(@inicio,@fin)}
          especialistas.each do |especialista|
                g.data("#{especialista.nombre}(#{especialista.num_orientaciones_periodo(@inicio,@fin)})", [especialista.num_orientaciones_periodo(@inicio,@fin)]) if especialista.num_orientaciones_periodo(@inicio,@fin) > 0
          end
      else
            g.title = "Total de orientaciones"
            especialistas.each do |especialista|
            total_sesiones = Orientacion.count(:id, :conditions => ["user_id = ?", especialista.id.to_i])
              if total_sesiones > 0
                g.data("#{especialista.nombre}", [total_sesiones])
              end
            end
      end
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

      @today = Time.now
      @sum_1_15 = Participante.count(:fecha_nac, :conditions => ["fecha_nac < ? AND fecha_nac >= ?", @today, @today.years_ago(15)])
      @sum_16_30 = Participante.count(:fecha_nac, :conditions => ["fecha_nac < ? AND fecha_nac >= ?", @today.years_ago(15), @today.years_ago(30)])
      @sum_31_45 = Participante.count(:fecha_nac, :conditions => ["fecha_nac < ? AND fecha_nac >= ?", @today.years_ago(30), @today.years_ago(45)])
      @sum_46_60 = Participante.count(:fecha_nac, :conditions => ["fecha_nac < ? AND fecha_nac >= ?", @today.years_ago(45), @today.years_ago(60)])
      @sum_60_mas = Participante.count(:fecha_nac, :conditions => ["fecha_nac < ?", @today.years_ago(60)])


      # --- Datos --
      g.data("de 1 a 15", [ @sum_1_15])
      g.data("de 16 a 30", [ @sum_16_30])
      g.data("de 31 a 45", [ @sum_31_45])
      g.data("de 46 a 60", [ @sum_46_60])
      g.data("más de 60", [ @sum_60_mas])
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
      g = Gruff::Pie.new
      g.title = "Trámites por materia"
      @materias = Materia.find(:all, :order => "descripcion")
      @materias.each do |materia|
        g.data("#{materia.descripcion}", [Tramite.count(:id, :conditions => ["materia_id = ?", materia.id])])
      end
      send_data(g.to_blob,:disposition => 'inline', :type => 'image/png', :filename => "list_by_materia.png")
  end


  def select_personas_atendidas
    
  end

  def search_personas_atendidas
    params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
    @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
    #@tramites = Tramite.find(:all, :conditions => ["created_at between ? AND ?",@inicio, @fin], :order => "created_at")
     @tramites = Tramite.find(:all, :select => "tramites.*", :joins => "tramites, orientacions orientacions, estatus e", :conditions => ["orientacions.tramite_id=tramites.id AND tramites.estatu_id=e.id AND e.clave in ('comp-conc', 'no-compar') AND (orientacions.fechahora between ? AND ?)", @inicio, @fin])
  end

  def show_cargas_trabajo
     especialistas = User.find_by_sql("select u.* from users u inner join roles_users ru on u.id=ru.user_id inner join roles r on ru.role_id=r.id Where r.name = 'especialistas' order by u.login")
     @especialistas = especialistas.sort{|p1,p2| p1.num_orientaciones_por_semana <=> p2.num_orientaciones_por_semana}
     return render(:partial => 'show_cargas_trabajo', :layout => 'only_jquery')
  end


end
