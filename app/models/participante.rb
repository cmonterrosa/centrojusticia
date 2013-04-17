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

  def before_save
    self.anio_nac = self.fecha_nac.year if (self.fecha_nac.year && self.anio_nac == Time.now.year.to_s)
  end

  def nombre_completo
    #"#{self.paterno} #{self.materno} #{self.nombre}"
    "#{self.nombre} #{self.paterno} #{self.materno}"
  end

  def edad
    if self.fecha_nac
      if self.fecha_nac.year != Time.now.year && self.fecha_nac.month != Time.now.month
        this_year = Time.now.year
        birth_year = (self.fecha_nac) ? self.fecha_nac.year : nil
        result = (birth_year)? (this_year - birth_year) : 0
        return result
      end
    end
    if self.anio_nac
      return Time.now.year.to_i - self.anio_nac.to_i
    end
  end


  def sexo_descripcion
    (self.sexo == "M")? "MASCULINO" : "FEMENINO"
  end



end
