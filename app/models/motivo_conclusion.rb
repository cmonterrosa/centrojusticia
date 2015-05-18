class MotivoConclusion < ActiveRecord::Base
  has_many :tramites

  def descripcion_articulo
    "Artículo #{self.articulo}, fracción #{self.fraccion}"
  end

  def descripcion_completa
    "#{descripcion_articulo}.- #{self.descripcion}"
  end


end
