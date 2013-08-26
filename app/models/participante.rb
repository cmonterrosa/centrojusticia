class Participante < ActiveRecord::Base
  belongs_to :comparecencia
  belongs_to :municipio
  belongs_to :user
  belongs_to :tipopersona
  belongs_to :cuadrante
  has_many :invitacions

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
    if self.fecha_nac
      self.anio_nac = self.fecha_nac.year if (self.fecha_nac.year && self.anio_nac == Time.now.year.to_s)
    end
  end

  def nombre_completo
    "#{self.nombre} #{self.paterno} #{self.materno}"
  end

  def edad
    if self.fecha_nac
      if self.fecha_nac.year != Time.now.year && self.fecha_nac.month != Time.now.month
        #this_year = Time.now.year
        #birth_year = (self.fecha_nac) ? self.fecha_nac.year : nil
        #result = (birth_year)? (this_year - birth_year) : 0
        return birthday
      end
    end
    if self.anio_nac
      return Time.now.year.to_i - self.anio_nac.to_i
    end
  end


  def sexo_descripcion
    (self.sexo == "M")? "MASCULINO" : "FEMENINO"
  end

  def birthday
    user = Participante.find(self.id)
    today = Date.today
    new = user.fecha_nac.to_date.change(:year => today.year)
    user = user.fecha_nac
    if Date.civil_to_jd(today.year, today.month, today.day) >= Date.civil_to_jd(new.year, new.month, new.day)
      age = today.year - user.year
    else
      age = (today.year - user.year) -1
    end
    age
  end

   def numero_expediente
     (self.folio_expediente) ?  "#{self.folio_expediente.to_s.rjust(4, '0')}/#{self.anio}" : nil
   end



end
