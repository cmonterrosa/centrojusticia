class Sesion < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :horario
  belongs_to :estatus_sesion
  belongs_to :user
  belongs_to :tiposesion
  belongs_to :sala
  has_one :invitacion

  #--- Validaciones --
  validates_uniqueness_of :clave
  #validates_presence_of :mediador_id
  #validates_presence_of :comediador_id
  #validates_format_of :num_tramite, :with => /^\d{1,4}\/20\d{2}$/, :message => " El formato debe de ser num/anio"
  #validates_uniqueness_of :horario_id, :scope => [:tramite_id, :tiposesion_id, :mediador_id]

 def initialize(params = nil)
    super
    self.notificacion = 0 unless self.notificacion
    self.concluida = 0 unless self.concluida
 end


  def start_at
    horario = Horario.find(self.horario_id) if self.horario_id
    fecha = DateTime.civil(self.fecha.year, self.fecha.month, self.fecha.day, horario.hora, horario.minutos) if self.fecha
    return (fecha) if fecha
    return nil
  end

  def mediador
    return (User.find(self.mediador_id)) if self.mediador_id
  end
  
  def comediador
    return (User.find(self.comediador_id)) if self.comediador_id
  end

  def title
    string=" "
    string << "Especialista: #{self.mediador.nombre_completo}       " if self.mediador
    string << " tipo: #{self.tiposesion.descripcion}     " if self.tiposesion
    string << "Sala: #{self.horario.sala.descripcion} " if self.horario.sala
    return string
  end

  def resume
    string = ""
    string << "[#{self.num_tramite}]    #{self.mediador.nombre.upcase}  " if self.mediador && self.num_tramite
    string << " Y  #{self.comediador.nombre.upcase}  " if self.comediador
    string << "  (#{self.tiposesion.descripcion}) " if self.tiposesion
    return string
  end

  def generate_clave
    id = maximo = (Sesion.maximum(:id)) ? (Sesion.maximum(:id)) : 1
    clave = Time.now.year.to_s[2,3] + id.to_s.rjust(4,"0")
    while not (Sesion.find_by_clave(clave)).nil?
      clave = Time.now.year.to_s[2,3] + (id + 1).to_s.rjust(4,"0")
    end
    self.clave = clave
  end

  def has_permission?(current_user)
    if current_user.has_role?("controlagenda") || self.user == current_user || self.mediador_id== current_user.id || current_user.has_role?("admindireccion")
       return true
     else
       return false
     end
  end

   def hora_completa
    case self.hora
    when (1..11)
      return "#{self.hora.to_s.rjust(2, '0')}:#{self.minutos.to_s.rjust(2, '0')} AM"
    when (12..24)
      return "#{self.hora.to_s.rjust(2, '0')}:#{self.minutos.to_s.rjust(2, '0')} PM"
    end
  end

  def cancel?(user=nil)
    self.cancel = true
    self.cancel_user = user.id if user
    self.save
  end

  def fecha_sugerida(especialista=nil,comediador=nil)
    ### Por regla buscamos tres dias hacia adelante ####
    @horarios = Horario.find(:all, :conditions => ["activo = true"], :order => "hora,minutos")
    especialista = User.find(especialista) if especialista
    comediador = User.find(comediador) if comediador
    
    ###-------- iteracion por dias ------  #######
     (10..30).each do |dia|
      puts dia
      @fecha = Time.now + (((60 * 60) * 24) * dia)
        ## Verifico si no es sabado o domingo ###
        if (1..5).include?(@fecha.wday)
            ### Empiezo a buscar en los horarios ####
            @horarios.each do |h|
                fecha_sesion = DateTime.civil(@fecha.year, @fecha.month, @fecha.day, h.hora, h.minutos)
                 if especialista && comediador
                   ### Si esta libre ####
                   puts "Buscando fecha.."
                   if (especialista.disponible?(fecha_sesion) && comediador.disponible?(fecha_sesion))
                     self.horario = h
                     self.fecha = fecha_sesion
                     return fecha_sesion
                   end
                 end
            end
        end
     end
     return nil
    end

end
