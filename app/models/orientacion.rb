class Orientacion < ActiveRecord::Base
  belongs_to :user
  belongs_to :tramite
  belongs_to :municipio
  belongs_to :estatu
  belongs_to :sala
  has_one :comparecencia

  #---- validaciones ---
  validates_presence_of :sala_id, :message => "Seleccione una sala"
  validates_presence_of :municipio_id, :message => "Seleccione una municipio"

  def solicitante
    "#{self.paterno} #{self.materno} #{self.nombre}"
  end

  before_save :mayusculas

  def mayusculas
    self.paterno.upcase! unless self.paterno.nil?
    self.materno.upcase! unless self.materno.nil?
    self.nombre.upcase! unless self.nombre.nil?
  end

 
end
