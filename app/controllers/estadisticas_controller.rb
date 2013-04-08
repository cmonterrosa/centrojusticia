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


  def grafica_orientaciones_especialistas
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
  @tramites = Tramite.find(:all, :conditions => ["created_at between ? AND ?",@inicio, @fin], :order => "created_at")
  end


end
