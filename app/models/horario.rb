class Horario < ActiveRecord::Base
  belongs_to :sala
  has_many :sesiones

  def hora_completa
    case self.hora
    when (1..12)
      return "#{self.hora.to_s.rjust(2, '0')}:#{self.minutos.to_s.rjust(2, '0')} am"
    when (13..24)
      return "#{self.hora.to_s.rjust(2, '0')}:#{self.minutos.to_s.rjust(2, '0')} pm"
    end
  end

  def descripcion_completa
    hora_completa + " (#{self.sala.descripcion.upcase})"
  end
end
