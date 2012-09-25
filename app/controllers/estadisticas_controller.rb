require 'rubygems'
require 'gruff'
class EstadisticasController < ApplicationController
  
  layout 'fancybox'

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


  


end
