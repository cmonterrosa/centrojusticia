class Participante < ActiveRecord::Base
  belongs_to :comparecencia
  belongs_to :municipio
  belongs_to :user

  def before_save
    self.paterno.upcase! if self.paterno
    self.materno.upcase! if self.materno
    self.nombre.upcase! if self.nombre
  end

  def nombre_completo
    "#{self.paterno} #{self.materno} #{self.nombre}"
  end



end
