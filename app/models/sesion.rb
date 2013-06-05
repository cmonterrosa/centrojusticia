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
    if current_user.has_role?("controlagenda") || self.user == current_user || self.mediador_id== current_user.id
       return true
     else
       return false
     end
  end

   def hora_completa
    case self.hora
    when (1..12)
      return "#{self.hora.to_s.rjust(2, '0')}:#{self.minutos.to_s.rjust(2, '0')} AM"
    when (13..24)
      return "#{self.hora.to_s.rjust(2, '0')}:#{self.minutos.to_s.rjust(2, '0')} PM"
    end
  end



end
