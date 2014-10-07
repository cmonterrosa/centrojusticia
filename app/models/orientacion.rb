class Orientacion < ActiveRecord::Base
  belongs_to :user
  belongs_to :tramite
  belongs_to :municipio
  belongs_to :estatu
  belongs_to :sala
  has_one :comparecencia

  #---- validaciones ---
  #validates_presence_of :sala_id, :message => "Seleccione una sala"
  #validates_presence_of :municipio_id, :message => "Seleccione una municipio"

  before_save :update_full_name


  def update_full_name
    self.full_name = solicitante if self.nombre && self.paterno
  end


  def solicitante
   # "#{self.paterno} #{self.materno} #{self.nombre}"
    "#{self.nombre} #{self.paterno} #{self.materno}"
  end
#
#  before_save :mayusculas
#
#  def mayusculas
##    self.paterno.upcase! unless self.paterno.nil?
##    self.materno.upcase! unless self.materno.nil?
##    self.nombre.upcase! unless self.nombre.nil?
#  end

  def especialista
    if self.especialista_id
       return User.find(self.especialista_id)
    else
      return nil
    end
  end

 
end
