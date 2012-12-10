require 'rubygems'
require 'gruff'
class EstadisticasController < ApplicationController
  layout 'oficial_fancy'

  def index

  end

  def grafica_sesiones_especialistas
      g = Gruff::Pie.new
      #g = Gruff::Bar.new
      g.title = "Sesiones por especialista"
      @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
      @especialistas.each do |especialista|
        total_sesiones = Sesion.count(:id, :conditions => ["mediador_id = ? and activa=true", especialista.id.to_i])
        if total_sesiones > 0
          g.data("#{especialista.nombre}", [total_sesiones])
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
      send_data(g.to_blob,:disposition => 'inline', :type => 'image/png', :filename => "list.png")
  end


  


end
