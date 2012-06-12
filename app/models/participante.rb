class Participante < ActiveRecord::Base
  belongs_to :comparecencia
  belongs_to :municipio
  belongs_to :user

  def nombre_completo
    "#{self.paterno} #{self.materno} #{self.nombre}"
  end

end
