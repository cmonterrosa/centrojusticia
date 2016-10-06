# Clase principal, columna vertebral, contiene los datos básicos del trámite
class Tramite < ActiveRecord::Base
  belongs_to :atencion
  belongs_to :subdireccion
  belongs_to :materia
  belongs_to :user
  belongs_to :estatu
  belongs_to :noprocedente
  belongs_to :motivo_conclusion
  belongs_to :mecanismo_alternativo
  has_one :orientacion
  has_one :comparecencia
  has_many :historias
  has_many :adjuntos
  has_many :sesions
  has_many :convenios


  # Validaciones
  validates_uniqueness_of :folio_expediente, :scope => :anio, :if => "self.anio.to_i > 2014",
    :allow_nil => true, :message => "ya se encuentra registrado"
  #validates_presence_of :subdireccion_id, :message => "Seleccione una subdireccion"


  def undo_status
    #--- ultimo estatus ---
    @historia = Historia.find(:first, :conditions => ["tramite_id = ?", self.id], :order => "created_at DESC")
    @historia.destroy
    #estatu  = Historia.find(:first, :select => "id", :conditions => ["tramite_id = ?", self.id], :order => "created_at DESC")
    #self.estatu = estatu.id if estatu
    #self.save
  end

  def folio_integrado
    "#{self.anio[2..4]}#{self.folio.to_s.rjust(5, '0')}"
  end

  # Despliega el folio inverso
  def folio_inverso
    (self.anio && self.folio)? "#{self.anio[2..4]}#{self.folio.to_s.rjust(5, '0')}" : false
  end

  def estatus
    result = (self.estatu ) ? self.estatu.descripcion : nil
    return result
  end


    # Actualización de estatus, guarda registro en tabla histórica que contiene usuario y fechahora
  def update_estatus!(clave,usuario)
    if !clave.nil? && !usuario.nil?
       if @estatus = Estatu.find_by_clave(clave)
          if self.estatu
              is_finish = (self.estatu.is_finish)? true : false
              #same_estatus = @estatus.descripcion == self.estatu.descripcion || false
              if @estatus.jerarquia >= self.estatu.jerarquia
                  self.update_attributes!(:estatu_id => @estatus.id)
              end
              #self.update_attributes!(:estatu_id => @estatus.id) if (!same_estatus && !is_finish)
          else
              self.update_attributes!(:estatu_id => @estatus.id)
          end
           Historia.create(:tramite_id => self.id, :estatu_id => @estatus.id, :user_id => usuario.id )
       end
   end
  end

  # Actualización de estatus, guarda registro en tabla histórica que contiene usuario y fechahora
  def update_estatus_old!(clave,usuario)
    @estatus = Estatu.find_by_clave(clave) if (!clave.nil? && !usuario.nil?)
     if @estatus 
        @history = Historia.new(:tramite_id => self.id, :estatu_id => @estatus.id, :user_id => usuario.id )
        # Verificamos si existe un estatus superior #
        tiene_historia = Historia.find(:all, :conditions => ["tramite_id = ? AND estatu_id = ?", self.id, @estatus.id])
        unless (self.estatu_id == @estatus.id)
          if @history.save
            #---- actualizacion del registro principal --
            self.update_attributes!(:estatu_id => @estatus.id) if tiene_historia.empty?
            return true
          end
        else
          return false
        end
     end
  end

  def update_estatus_with_especialista!(clave,usuario,especialista=nil,justificacion=nil)
    @estatus = Estatu.find_by_clave(clave) if (!clave.nil? && !usuario.nil?)
    @especialista = (especialista) ? especialista.id : nil
    @justificacion = (justificacion) ? Justificacion.find(justificacion).id : nil
    @history = Historia.new(:tramite_id => self.id, :estatu_id => @estatus.id, :user_id => usuario.id, :especialista_id => @especialista, :justificacion_id => @justificacion ) if @estatus
    if @history.save
      #---- actualizacion del registro principal --
      self.update_attributes!(:estatu_id => @estatus.id)
      return true
    end
  end

  def update_flujo_estatus!(usuario,new_st=nil)
       ids = []
       usuario.roles.each do |role| ids << role.id end
       @flujo = Flujo.find(:first, :conditions => ["old_status_id = ? and role_id in (?)", self.estatu_id, ids])
       new_estatus = (new_st) ? new_st.id : @flujo.new_status_id if (@flujo || new_st)
       @history = Historia.new(:tramite_id => self.id, :estatu_id => new_estatus, :user_id => usuario.id ) if new_estatus
       if @history && @history.save
            #---- actualizacion del registro principal --
            self.update_attributes!(:estatu_id => @history.estatu_id)
            return true
       end
   end

   def generar_folio
     unless self.folio
        anio = self.anio
        maximo=  Tramite.maximum(:folio, :conditions => ["anio = ?", anio])
        folio = 1 unless maximo
        folio ||= maximo.to_i + 1
        self.folio = folio
     end
   end

   def generar_folio_expediente!#_anterior!
     self.transaction do
        #self.reload(:lock => true)
        unless self.folio_expediente
          anio = self.anio
          maximo=  Tramite.maximum(:folio_expediente, :conditions => ["anio = ?", anio])
          folio = 1 unless maximo
          folio ||= maximo.to_i + 1
          self.update_attributes!(:folio_expediente => folio) if Tramite.find(self.id)
      end
     end
   end

   # Llama procedimiento almacenado que genera el siguiente numero de expediente
   def generar_folio_expediente!
   #   ActiveRecord::Base.connection.execute("CALL update_folio_consecutivo(#{self.anio}, #{self.id})") if (self.anio && self.id) && !self.folio_expediente
   end

   def numero_expediente
     (self.folio_expediente) ?  "#{self.folio_expediente.to_s.rjust(4, '0')}/#{self.anio}" : nil
   end

   def cancel(usuario)
        if usuario
          self.fecha_fin = Time.now
          (self.update_estatus!("tram-canc", usuario)) ? true : false
        end
   end

   def has_estatus?(estatus)
     (self.estatu == Estatu.find_by_clave(estatus)) ? true : false
   end

   def concluido
     Concluido.find(:first, :conditions => ["tramite_id = ?", self.id], :order => "updated_at") if self.id
   end

   # Regresa el valor true o false dependiendo si el trámite ya fue concluido
   def concluido?
     Concluido.count(:id, :conditions => ["tramite_id = ?", self.id], :order => "updated_at") > 0 if self.id
   end

   def fecha_conclusion
     tramite_concluido = concluido
     if tramite_concluido && tramite_concluido.created_at
       "[#{tramite_concluido.created_at.strftime('%d DE %B DE %Y - %H:%M %p').upcase}]"
     end
   end

   def causa_conclusion
     tramite_concluido = concluido
     if tramite_concluido && tramite_concluido.motivo_conclusion
       "#{tramite_concluido.motivo_conclusion.descripcion_completa}"
     end
   end

   def solicitante_orientacion
     solicitante = (self.orientacion) ? self.orientacion.solicitante : nil
     solicitante ||= (Extraordinaria.count(:id, :conditions => ["tramite_id = ?", self.id]) > 0) ? Extraordinaria.find_by_tramite_id(self.id, :select => "id,paterno,materno,nombre").solicitante : "No existe informacion"
     return solicitante
   end


  def self.search(search, perfil=nil)
    if search && search  =~ /^\d{1,4}\/20\d{2}$/
      folio, anio = search.split("/")
      find(:all,  :conditions => ['anio = ? AND folio_expediente = ?', anio, folio])
    else
      if perfil && perfil == 'convenios'
        find(:all, :select => "t.*", :joins => "t, convenios c", :conditions => "t.id=c.tramite_id", :group => "t.id")
      else
        find(:all, :conditions => ["folio_expediente IS NOT NULL"], :order => "anio DESC, folio_expediente DESC")
      end
    end
  end



end
