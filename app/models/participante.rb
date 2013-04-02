class Participante < ActiveRecord::Base
  belongs_to :comparecencia
  belongs_to :municipio
  belongs_to :user
  belongs_to :tipopersona

  #def before_save
    #self.paterno.upcase! if self.paterno
    #self.materno.upcase! if self.materno
    #self.nombre.upcase! if self.nombre
    #self.apoderado_legal.upcase! if self.apoderado_legal
    #self.razon_social.upcase! if self.razon_social
    #self.domicilio.upcase! if self.domicilio
    #self.referencia_domiciliaria.upcase! if self.referencia_domiciliaria
  #end

  def nombre_completo
    "#{self.paterno} #{self.materno} #{self.nombre}"
  end

  def edad
    this_year = Time.now.year
    birth_year = (self.fecha_nac) ? self.fecha_nac.year : nil
   (birth_year)? (this_year - birth_year) : 0
  end

  def sexo_descripcion
    (self.sexo == "M")? "MASCULINO" : "FEMENINO"
  end



end
