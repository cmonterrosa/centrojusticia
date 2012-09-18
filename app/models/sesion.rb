class Sesion < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :horario
  belongs_to :estatus_sesion
  belongs_to :user
  belongs_to :tiposesion
  belongs_to :sala

    #--- Validaciones --
    validates_uniqueness_of :clave
    validates_presence_of :mediador_id
    validates_presence_of :comediador_id

  def start_at
    horario = Horario.find(self.horario_id) if self.horario_id
    fecha = DateTime.civil(self.fecha.year, self.fecha.month, self.fecha.day, horario.hora, horario.minutos)
    return (fecha) if fecha
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
    clave = (rand(10)).to_s + Array.new(2) { (rand(122-97) + 97).chr }.join + (rand(1000)).to_s.rjust(2, "0")
    while not (Sesion.find_by_clave(clave)).nil?
      clave = (rand(10)).to_s + Array.new(2) { (rand(122-97) + 97).chr }.join + (rand(1000)).to_s.rjust(2, "0")
    end
    self.clave = clave
    self.save!
  end

  def has_permission?(current_user)
     if current_user.has_role?("controlagenda") || self.user == current_user
       return true
     else
       return false
     end
  end



end
