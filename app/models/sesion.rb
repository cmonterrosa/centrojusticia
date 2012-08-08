class Sesion < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :estatus_sesion

  def mediador
    return (User.find(self.mediador_id)) if self.mediador_id
  end
  
  def comediador
    return (User.find(self.comediador_id)) if self.comediador_id
  end

  def title
    string=""
    string << "M: #{self.mediador.nombre_completo}" if self.mediador
    string << " CM: #{self.comediador.nombre_completo}" if self.comediador
    return string
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
