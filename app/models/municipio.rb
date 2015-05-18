class Municipio < ActiveRecord::Base
  belongs_to :estado
  has_many :orientacions
  has_one :subdireccion

  def descripcion_jerarquica
    desc=""
    desc<< "#{self.estado.descripcion}  /  " if self.estado
    desc << "#{self.descripcion}" if self.descripcion
    return desc
  end

end
