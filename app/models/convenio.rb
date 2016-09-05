class Convenio < ActiveRecord::Base
  belongs_to :tramite
  has_many :adjuntos, :conditions => "activo = true"
  validates_uniqueness_of :folio, :scope => "tramite_id", :allow_blank => true, :message => "ya ha sido tomado"
  ## Callbacks ###
  before_save :generate_folio
  before_destroy :eliminar_adjuntos
  before_destroy :eliminar_seguimientos
  has_many :seguimientos

  def generate_folio
    unless self.folio
      if self.tramite
        contador = Convenio.count(:id, :conditions => ["tramite_id = ?", self.tramite.id])
        if contador == 0
          contador = 1
        else
          maximo = Convenio.maximum(:folio, :conditions => ["tramite_id = ?", self.tramite_id])
          folio_expediente,anio,folio = maximo.split("/")
          contador = ((folio.to_i) +1) if folio
        end
        self.folio = (self.tramite && self.tramite.numero_expediente)? "#{self.tramite.numero_expediente}/#{contador}" : nil if contador
      end
    end
  end


  def especialista
    return (User.find(self.especialista_id)) if self.especialista_id
  end

   def eliminar_adjuntos
     @adjuntos = Adjunto.find(:all, :conditions => ["convenio_id", self.id])
     @adjuntos.each do |a|
       a.mark_as_deleted
     end
   end

   def eliminar_seguimientos
     @seguimientos = Seguimiento.find(:all, :conditions => ["convenio_id", self.id])
     @seguimientos.each do |s|
       s.destroy
     end
   end

   def numero_adjuntos
     return Adjunto.count(:convenio_id, :conditions => ["convenio_id = ?", self.id])
   end


end
