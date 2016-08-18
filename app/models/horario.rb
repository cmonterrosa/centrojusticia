#!/bin/env ruby
# encoding: utf-8
class Horario < ActiveRecord::Base
  belongs_to :sala
  has_many :sesiones

  #before_save :set_default_fecha_expiracion


  # Establece si no está activo la fecha de expiracion
  def set_default_fecha_expiracion
    self.fecha_expiracion ||= Time.now unless  self.activo == true
    self.fecha_expiracion = nil if self.activo == true
  end

  def hora_completa
    case self.hora
    when (1..12)
      return "#{self.hora.to_s.rjust(2, '0')}:#{self.minutos.to_s.rjust(2, '0')} am"
    when (13..24)
      return "#{self.hora.to_s.rjust(2, '0')}:#{self.minutos.to_s.rjust(2, '0')} pm"
    end
  end

  def hora_completa_turno
    minutos = self.minutos.to_s.rjust(2, '0')
    case self.hora
    when (1..11)
      return "a las #{self.hora.to_s}:#{minutos} de la mañana"
    when (12)
      return "a las 12:#{minutos} del día"
    when (13)
      return "a la 1:#{minutos} de la tarde"
    when (14..18)
      return "a las #{(self.hora.to_i - 12).to_s}:#{minutos} de la tarde"
    when (19..24)
      return "a las #{(self.hora.to_i - 12).to_s}:#{minutos} de la noche"
    end
  end

  def descripcion_completa
    hora_completa + " (#{self.sala.descripcion.upcase})"
  end
end
