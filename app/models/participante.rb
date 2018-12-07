require 'time'

class Participante < ActiveRecord::Base
  belongs_to :comparecencia
  belongs_to :municipio
  belongs_to :pais
  belongs_to :user
  belongs_to :tipopersona
  belongs_to :cuadrante
  belongs_to :etnia
  belongs_to :estado_civil
  has_many :invitacions
  has_many :seguimientos

  #campos requeridos por estadistica
  belongs_to :fuente_ingreso
  belongs_to :tipovivienda
  belongs_to :servicio_medico
  belongs_to :ocupacion
  belongs_to :alfabetismo
  belongs_to :estado_psicofisico
  belongs_to :tipoasesor
  belongs_to :calidad_migratoria
  belongs_to :estatus_migratorio  
  belongs_to :nivel_academico

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

    if self.nombre && self.paterno
      self.full_name =  "#{self.nombre} #{self.paterno} #{self.materno}"
    end

  end

  def nombre_completo
    if self.nombre.nil? && self.paterno.nil? && self.materno.nil?
      "#{self.razon_social}"
    else
      "#{self.nombre} #{self.paterno} #{self.materno}"
    end
  end

  def rol_nombre_completo
    "#{self.perfil}  /  #{nombre_completo}"
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
    if Date.civil(today.year, today.month, today.day) >= Date.civil(new.year, new.month, new.day)
      age = today.year - user.year
    else
      age = (today.year - user.year) -1
    end
    age
  end

   def numero_expediente
     (self.folio_expediente) ?  "#{self.folio_expediente.to_s.rjust(4, '0')}/#{self.anio}" : nil
   end

   def originario
     mexico = Pais.find_by_clave("MX")
     pais = (self.pais) ? (self.pais) : mexico
     ## Si es mexicano ##
     (desc = (pais == mexico) ? self.municipio.descripcion_jerarquica : nil) if self.municipio_id
     ## Si es extranjero ##
     (desc ||= (pais) ? self.pais.descripcion : '') if self.pais_id
     ## Si especifico que no sabe procedencia
     (self.sabe_procedencia && self.sabe_procedencia == "NO") ? "" : desc
   end

   def articulo_por_su_genero
      (self.sexo == 'F')? 'LA' : 'EL' if self.sexo
   end

   ###################################
   # Funciones que obtienen el domicilio actual
   #
   ###################################

   def tipo_domicilio_ubicacion
      if self.domicilio && self.domicilio.size > 1
        return "DOMICILIO PERSONAL"
      elsif self.domicilio_laboral && self.domicilio_laboral.size > 1
        return "DOMICILIO LABORAL"
      else
        "DOMICILIO"
      end
   end

    def domicilio_ubicacion
      if self.domicilio && self.domicilio.size > 1
       self.domicilio
     elsif self.domicilio_laboral && self.domicilio_laboral.size > 1
       self.domicilio_laboral
     else
       ""
     end
    end

   def domicilio_referencias_ubicacion
     referencia=""
     case tipo_domicilio_ubicacion
     when "DOMICILIO PERSONAL"
        referencia = self.referencia_domiciliaria if self.referencia_domiciliaria && self.referencia_domiciliaria.size > 1
     when "DOMICILIO LABORAL"
       referencia = self.referencias_domiciliares_laboral if self.referencias_domiciliares_laboral && self.referencias_domiciliares_laboral.size > 1
     end
     return referencia
   end

   # Metodo que busca una persona o personas
  def self.search(search)
    if search
      find(:all, :conditions => ['( CONCAT(nombre, \' \' , paterno, \' \' , materno) LIKE ?)
            OR ((CONCAT(SUBSTRING_INDEX( `nombre` , \' \', 1 ), \' \' , paterno) LIKE ?))
            OR (razon_social LIKE ?)', "%#{search}%", "%#{search}%", "%#{search}%"], :order => "created_at DESC, paterno, materno, nombre, razon_social", :limit => 225)
    else
      find(:all)
    end
  end

  


end
