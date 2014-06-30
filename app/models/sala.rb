require 'date'
class Sala < ActiveRecord::Base
  belongs_to :subdireccion
  has_many :orientacions
  has_many :horarios
  has_many :sesions

  def libre?(horario_id = nil, fecha=nil)
    @ocupada=nil
    if horario_id && fecha
      fecha = fecha.strftime("%Y-%m-%d")
      @ocupada = Sesion.find(:first, :conditions => ["fecha= ? AND sala_id = ? AND horario_id = ? AND activa = ?", fecha, self.id, horario_id, true])
    end
    return ((@ocupada)? false  : true)
  end

end
