class InstitucionAcademica < ActiveRecord::Base
  has_many :formacions
  
  def descripcion_completa
    "#{self.siglas} | #{self.descripcion}"
  end
end
