class Orientacion < ActiveRecord::Base
  belongs_to :municipio
  belongs_to :estatu
  belongs_to :sala
  has_one :comparecencia

  def solicitante
    "#{self.paterno} #{self.materno} #{self.nombre}"
  end

  before_save :init

  def init
      estatus = Estatu.find_by_descripcion("Activa")
      self.estatu_id ||= estatus.id
  end

end
