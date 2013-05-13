class Tramite < ActiveRecord::Base
  belongs_to :subdireccion
  belongs_to :materia
  belongs_to :user
  belongs_to :estatu
  has_one :orientacion
  has_one :comparecencia
  has_many :historias
  has_many :adjuntos
  has_many :sesions

  #---- Validaciones ----
  #validates_uniqueness_of :folio, :scope => :anio
  #validates_presence_of :subdireccion_id, :message => "Seleccione una subdireccion"


  def undo_status
    #--- ultimo estatus ---
    @historia = Historia.find(:first, :conditions => ["tramite_id = ?", self.id], :order => "created_at DESC")
    @historias.destroy
    self.estatu = Historia.find(:first, :select => "id", :conditions => ["tramite_id = ?", self.id], :order => "created_at DESC")
    self.save
  end

  def folio_integrado
   # "#{self.anio}/#{self.folio}"
   "#{self.anio[2..4]}#{self.folio.to_s.rjust(5, '0')}"
  end

  def folio_inverso
    "#{self.anio[2..4]}#{self.folio.to_s.rjust(5, '0')}"
     #"#{self.folio}/#{self.anio}"
  end

  def estatus
    result = (self.estatu ) ? self.estatu.descripcion : nil
    return result
  end

  def update_estatus!(clave,usuario)
    @estatus = Estatu.find_by_clave(clave) if (!clave.nil? && !usuario.nil?)
    @history = Historia.new(:tramite_id => self.id, :estatu_id => @estatus.id, :user_id => usuario.id ) if @estatus
    if @history.save
      #---- actualizacion del registro principal --
      self.update_attributes!(:estatu_id => @estatus.id)
      return true
    end
  end

  def update_flujo_estatus!(usuario)
       ids = []
       usuario.roles.each do |role| ids << role.id end
       @flujo = Flujo.find(:first, :conditions => ["old_status_id = ? and role_id in (?)", self.estatu_id, ids])
       @history = Historia.new(:tramite_id => self.id, :estatu_id => @flujo.new_status_id, :user_id => usuario.id ) if @flujo
       if @history.save
          #---- actualizacion del registro principal --
          self.update_attributes!(:estatu_id => @history.estatu_id)
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

   def generar_folio_expediente!
      anio = self.anio
      maximo=  Tramite.maximum(:folio_expediente, :conditions => ["anio = ?", anio])
      folio = 1 unless maximo
      folio ||= maximo.to_i + 1
      self.update_attributes!(:folio_expediente => folio) if folio
   end

   def numero_expediente
     (self.folio_expediente) ?  "#{self.folio_expediente.to_s.rjust(4, '0')}/#{self.anio}" : nil
   end



end
