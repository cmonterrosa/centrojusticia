require 'date'
class Agenda
  def initialize(sesion=nil)
      puts "inicializando objeto..."
      @fecha_calculo = DateTime.now
      @hora = @minuto = @dia = @anio = 0
  end

  attr_accessor :hora, :minuto, :dia, :anio

  def consultar_agenda

  end


  def reprogramar_agenda
    
  end









end