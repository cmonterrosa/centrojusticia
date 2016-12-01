class Lactancia < ActiveRecord::Base
  belongs_to :user

#  def horario
#    ahora = Time.now
#    nueva_fecha = DateTime.civil(ahora.year, ahora.month, ahora.day, self.hora, self.minutos) if (self.hora && self.minutos)
#    return (nueva_fecha) if nueva_fecha
#    return nil
#  end
end
