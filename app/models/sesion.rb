require 'date'
class Sesion < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :horario
  belongs_to :estatus_sesion
  belongs_to :user
  belongs_to :tiposesion
  belongs_to :sala
  has_one :invitacion

  #--- Validaciones --
  #validates_uniqueness_of :clave
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
    horario = (self.horario_id) ? Horario.find(:first, :conditions => ["id = ?", self.horario_id]) : nil
    horario ||= Horario.find(:first, :conditions => ["hora = ? AND minutos = ? AND sala_id = ? AND activo != 0", self.hora, self.minutos, self.sala_id])
    nueva_fecha = DateTime.civil(self.fecha.year, self.fecha.month, self.fecha.day, horario.hora, horario.minutos) if self.fecha && horario
    return (nueva_fecha) if nueva_fecha
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
    #string << "[#{self.num_tramite}]    #{self.mediador.nombre.upcase}  " if self.mediador && self.num_tramite
    string << "[#{self.tramite.numero_expediente}]    #{self.mediador.nombre.upcase}  " if self.mediador && self.tramite
    string << " Y  #{self.comediador.nombre.upcase}  " if self.comediador
    string << "  (#{self.tiposesion.descripcion}) " if self.tiposesion
    return string
  end

  def descripcion_especialistas
    string = ""
    #string << "[#{self.start_at.strftime('%d de %B de %Y')} / #{self.hora_completa}]  " if self.start_at
    string << "#{self.mediador.nombre.upcase}  " if self.mediador
    string << " Y  #{self.comediador.nombre.upcase}  " if self.comediador
    string << "  (#{self.tiposesion.descripcion}) \r" if self.tiposesion
    return string
  end

  def resume_with_observaciones
    string = ""
    string << resume
    string << "      #{self.observaciones.strip[0..15]}" if self.observaciones
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

  def fechahora_completa
    nueva_fecha = self.start_at
    if nueva_fecha
      case self.hora
          when (1..11)
            return "#{nueva_fecha.strftime('%d DE %B DE %Y')}, A LAS #{self.hora.to_s.rjust(2, '0')}:#{self.minutos.to_s.rjust(2, '0')} HORAS".gsub(/^0/, '').upcase
          when (12)
            return "#{nueva_fecha.strftime('%d DE %B DE %Y')}, A LAS #{self.hora.to_s.rjust(2, '0')}:#{self.minutos.to_s.rjust(2, '0')} HORAS".gsub(/^0/, '').upcase
          when (13)
            return "#{nueva_fecha.strftime('%d DE %B DE %Y')}, A LAS #{self.hora.to_s.rjust(2, '0')}:#{self.minutos.to_s.rjust(2, '0')} HORAS".gsub(/^0/, '').upcase
          when (12..18)
            return "#{nueva_fecha.strftime('%d DE %B DE %Y')}, A LAS #{self.hora.to_s.rjust(2, '0')}:#{self.minutos.to_s.rjust(2, '0')} HORAS".gsub(/^0/, '').upcase
          when (19..24)
            return "#{nueva_fecha.strftime('%d DE %B DE %Y')}, A LAS #{self.hora.to_s.rjust(2, '0')}:#{self.minutos.to_s.rjust(2, '0')} HORAS".gsub(/^0/, '').upcase
      end
    end
   end

  def cancel!(user=nil)
    self.cancel = true
    self.cancel_user = user.id if user
    self.activa = false
    self.save
  end

  def cancel_registro_anterior!(user=nil)
    self.cancel = true
    self.cancel_user = user.id if user
    
    ## Cancelamos los movimientos ####
    @sesion = self
    if @sesion.num_tramite
      @ensesion = Situacion.find_by_descripcion("EN SESION")
      @especialista = Movimiento.find(:first, :conditions => ["(? between fecha_inicio AND fecha_fin) AND user_id = ? AND situacion_id = ?", (@sesion.start_at).strftime("%y-%m-%d %H:%M:%S"), @sesion.mediador_id, @ensesion.id]) if @sesion.start_at
      @comediador = Movimiento.find(:first, :conditions => ["(? between fecha_inicio AND fecha_fin) AND user_id = ? AND situacion_id = ?", (@sesion.start_at).strftime("%y-%m-%d %H:%M:%S"), @sesion.comediador_id, @ensesion.id]) if @sesion.start_at
      @especialista2 = Movimiento.find(:first, :conditions => ["user_id = ? AND observaciones like ?", @sesion.mediador_id, "ESPECIALISTA EN SESION, EXP. #{@sesion.num_tramite}%"])
      @comediador2 = Movimiento.find(:first, :conditions => ["user_id = ? AND observaciones like ?",  @sesion.comediador_id, "COMEDIADOR EN SESION, EXP. #{@sesion.num_tramite}%"])
    end
    if self.save
      @especialista.destroy if @especialista
      @comediador.destroy if @comediador
      @especialista2.destroy if @especialista2
      @comediador2.destroy if @comediador2
    end
  end


  def canceled?
    (self.cancel == true || self.cancel == 1)? true : false
  end

  def rehabilitar!
    self.cancel_user = false if !(self.cancel==1)
    self.cancel =false if (self.cancel==1)
    self.save
  end

  def fecha_sugerida(especialista=nil,comediador=nil)
    ### Por regla buscamos tres dias hacia adelante ####
    @horarios = Horario.find(:all, :conditions => ["activo = true"], :order => "hora,minutos")
    especialista = User.find(especialista) if especialista
    comediador = User.find(comediador) if comediador
    
    ###-------- iteracion por dias ------  #######
     (0..30).each do |dia|
      puts dia
      @fecha = (dias_habiles(DateTime.now, 10) + (dia))
        ## Verifico si no es sabado o domingo ###
        contador_dias=1
        if (1..5).include?(@fecha.wday)
            ### Empiezo a buscar en los horarios ####
            @horarios.each do |h|
                fecha_sesion = DateTime.civil(@fecha.year, @fecha.month, @fecha.day, h.hora, h.minutos)
                 if especialista && comediador
                   ### Si esta libre ####
                   puts "Buscando fecha dia:#{contador_dias}"
                   if (especialista.disponible?(fecha_sesion) && comediador.disponible?(fecha_sesion))
                     self.horario = h
                     self.fecha = fecha_sesion
                     return fecha_sesion
                   end
                 end
            end
            contador_dias+=1
        end
     end
     return nil
    end



  

  def dias_habiles(fecha=DateTime.now, total_dias=nil)
    total_dias = (total_dias) ? total_dias : 10
    habiles=0
    fecha_final=fecha
    while habiles < total_dias  do
      unless inhabil?(fecha + habiles)
         puts("dia habil : #{fecha + habiles}" )
         habiles +=1
         fecha_final = (fecha + habiles)
      else
         fecha+=1
      end
    end
    return fecha_final
  end

  def inhabil?(date=Time.now)
    inhabil = ((1..5)===date.wday) ? false : true
    if inhabil
       return true
    else
       if Festivo.find(:first, :conditions => ["? between fecha_inicio and fecha_fin", date])
         return true
       else
         return false
       end
    end
  end


def diez_dias_habiles(fecha=DateTime.now)
    now = DateTime.parse(fecha.strftime("%Y-%m-%d") + " 00:01")
    case now.wday
    when 1
      fecha = DateTime.parse((now + 11).strftime("%Y-%m-%d") + " 00:00")
    when 2
      fecha = DateTime.parse((now + 12).strftime("%Y-%m-%d") + " 00:00")
    when 3
      fecha = DateTime.parse((now + 13).strftime("%Y-%m-%d") + " 00:00")
    when 4
      fecha = DateTime.parse((now + 14).strftime("%Y-%m-%d") + " 00:00")
    when 5
      fecha = DateTime.parse((now + 15).strftime("%Y-%m-%d") + " 00:00")
    when 6
      fecha = DateTime.parse((now + 16).strftime("%Y-%m-%d") + " 00:00")
    else
      fecha = DateTime.parse((now + 17).strftime("%Y-%m-%d") + " 00:00")
    end
    puts fecha.strftime("%d/%m/%Y")
    return fecha
  end

end
