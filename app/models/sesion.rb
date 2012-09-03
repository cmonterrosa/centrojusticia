class Sesion < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :horario
  belongs_to :estatus_sesion
  belongs_to :user
  belongs_to :tiposesion
  belongs_to :sala

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
    string=""
    string << "Especialista: #{self.mediador.nombre_completo}       " if self.mediador
    string << " tipo:#{self.tiposesion.descripcion}     " if self.tiposesion
    string << "Sala: #{self.horario.sala.descripcion}" if self.horario.sala
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



  #---- metodo para buscar horario ----

  def get_horario
    #-- verificamos si existe para el día y hora de preferencia
    @tramite = self.tramite
    @dia_preferencia = @tramite.comparecencia.dia_preferencia
    @hora_preferencia = @tramite.comparecencia.hora_preferencia
    @ultima_sesion =  Sesion.find(:all, :order => "start_at DESC")
    @ultima_sesion_mes = @ultima_sesion.month if @ultima_sesion
    @ultima_sesion_dia = @ultima_sesion.yday if @ultima_sesion
    if HORAS_ATENCION.include?(@hora_preferencia)
      # DateTime.parse('0001-01-01 00:00:00').strftime('%Y-%m-%d %H:%M:%S')




    else

      # buscamos la hora más próxima


    end

    #--- horario libre (8-2) / (5-9) ---





  end



end
