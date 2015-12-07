class MotivoConclusion < ActiveRecord::Base
  has_many :tramites

  def descripcion_articulo
    self.fundamento
  end

  def descripcion_completa
    "#{self.fundamento}.- #{self.causa}"
  end


end
