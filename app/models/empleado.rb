class Empleado < ActiveRecord::Base
  has_one :user
  belongs_to :municipio
  belongs_to :subdireccion
  
  def nombre_completo
    "#{self.nombre.strip} #{self.paterno.strip} #{self.materno.strip}"
  end

end
