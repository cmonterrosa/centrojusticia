class Tramite < ActiveRecord::Base
  belongs_to :subdireccion
  belongs_to :materia
  belongs_to :user
  belongs_to :estatu
  has_one :orientacion
  has_one :comparecencia
  has_many :historias

  def folio_integrado
    "#{self.anio}/#{self.folio}"
  end

  def estatus
    @descripcion = "No existe información"
    @historia = Historia.find(:first, :conditions => ["tramite_id = ?", self.id], :order => "created_at DESC")
    return @descripcion unless @historia
    if @historia.estatu
      @descripcion = @historia.estatu.descripcion
    end
    return @descripcion
  end

  def update_estatus!(clave,usuario)
    @estatus = Estatu.find_by_clave(clave) if (!clave.nil? && !usuario.nil?)
    @history = Historia.new(:tramite_id => self.id, :estatu_id => @estatus.id, :user_id => usuario.id ) if @estatus
    if @history.save
      return true
    end
  end
 


   def generar_folio
      anio = self.anio
      maximo=  Tramite.maximum(:folio, :conditions => ["anio = ?", anio])
      folio = 1 unless maximo
      folio ||= maximo.to_i + 1
      self.folio = folio
   end



end
