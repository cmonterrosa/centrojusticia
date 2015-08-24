require 'digest/sha1'
require 'date'

class User < ActiveRecord::Base

  attr_accessor :puntaje_final
  
  has_many :comparecencias
  has_many :participantes
  has_many :tramites
  has_many :orientacions

  
  # ---------------------------------------
  # The following code has been generated by role_requirement.
  # You may wish to modify it to suit your need
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :materias
  has_and_belongs_to_many :cuadrantes
  belongs_to :subdireccion
  belongs_to :situacion
  belongs_to :empleado
  
  # has_role? simply needs to return true or false whether a user has a role or not.  
  # It may be a good idea to have "admin" roles return true always
  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    return true if @_list.include?("admin")
    (@_list.include?(role_in_question.to_s) )
  end
  # ---------------------------------------
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :nombre,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :nombre,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  after_create :default_subdireccion
  before_create :make_activation_code 

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :paterno, :materno, :nombre, :direccion, :activo, :tel_celular, :last_login, :categoria, :num_orientaciones_por_semana, :full_description_for_especialistas, :num_orientaciones_dos_dias, :situacion_id, :empleado_id, :subdireccion_id, :last_ip


  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end
  
  def recently_activated?
    @activated
  end

  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password, last_ip=nil)
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL and activo=true', login] # need to get the salt
    u && u.authenticated?(password) && u.update_attributes!(:last_login => Time.now, :last_ip => last_ip) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def nombre_completo
    string = ""
    string << "#{self.nombre.strip} " if self.nombre
    string << "#{self.paterno.strip} " if self.paterno
    string << "#{self.materno.strip}" if self.materno
  end

  ##### Puntuaciones #######

     def num_orientaciones_periodo_old(inicio,fin)
        numero_orientaciones = Orientacion.count(:especialista_id, :joins => "orientacions, tramites t, estatus e", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in ('comp-conc', 'no-compar', 'mate-asig', 'tram-admi', 'fech-asig') AND (orientacions.especialista_id = ? ) AND (orientacions.fechahora between ? AND ?)", self.id, inicio, fin])
        return numero_orientaciones
     end

     def num_orientaciones_periodo(inicio=Time.now,fin=Time.now)
       inicio = inicio.strftime("%Y-%m-%d %H:%M:%S")
       fin = fin.strftime("%Y-%m-%d %H:%M:%S")
       num_orientaciones= Orientacion.find_by_sql("select count(orientacions.id) as numero_orientaciones from orientacions orientacions inner join tramites t
      on orientacions.tramite_id=t.id inner join estatus e on t.estatu_id=e.id
      where (orientacions.especialista_id = #{self.id} )
      AND e.clave in ('comp-conc', 'no-compar', 'mate-asig', 'tram-admi', 'fech-asig', 'camb-sesi', 'tram-conc')
      AND (orientacions.fechahora between '#{inicio}' AND '#{fin}')")
      return num_orientaciones.first.numero_orientaciones.to_i
     end


    def num_orientaciones_desde_inicio_semana
    now = DateTime.parse(Time.now.strftime("%Y-%m-%d") + " 08:00")
    dia_semana = Time.now.wday

    case dia_semana
    when 1
      inicio_semana = now
      fin_semana = DateTime.parse((now + 5).strftime("%Y-%m-%d") + " 20:00")
    when 2
      inicio_semana = (now -1 )
      fin_semana = DateTime.parse((now + 4).strftime("%Y-%m-%d") + " 20:00")
    when 3
      inicio_semana = (now - 2)
      fin_semana = DateTime.parse((now + 3).strftime("%Y-%m-%d") + " 20:00")
    when 4
      inicio_semana = (now - 3)
      fin_semana = DateTime.parse((now + 2).strftime("%Y-%m-%d") + " 20:00")
    when 5
      inicio_semana = (now - 4)
      fin_semana = DateTime.parse((now + 1).strftime("%Y-%m-%d") + " 20:00")
    else
      inicio_semana = (now - 5)
      fin_semana = DateTime.parse((now).strftime("%Y-%m-%d") + " 20:00")
    end
    return num_orientaciones_periodo(inicio_semana,fin_semana)
  end

  def puntuacion_mes_actual
    primer_dia_mes= DateTime.parse("#{Time.now.year}-#{Time.now.month}-1 00:01")
    return num_orientaciones_periodo(primer_dia_mes,Time.now)
  end

  def puntuacion_anio_actual
    primer_dia_anio= DateTime.parse("#{Time.now.year}-01-01 00:01")
    return num_orientaciones_periodo(primer_dia_anio,Time.now)
  end

  def puntuacion_semana_actual
    return (num_orientaciones_desde_inicio_semana)
  end

  def puntuacion_general
      return ((puntuacion_semana_actual.to_i) + ((puntuacion_mes_actual.to_i) * 0.01))
  end


  def full_description_for_especialistas
    if self.situacion
         "#{self.estatus_actual}".ljust(18) +   " | "  +   "#{self.nombre_completo}".ljust(40)  +  " | " +  "#{self.puntuacion_semana_actual}"
    else
      nombre_completo
    end
  end

  def num_orientaciones_por_semana
      now = Date.today + 1
      seven_days_ago = (now - 7)
      #numero_orientaciones = Orientacion.find_by_sql("SELECT count(o.especialista_id) AS count_especialista_id FROM `orientacions` o, tramites t, estatus e WHERE (o.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in ('comp-conc', 'no-compar') AND (o.especialista_id = 10 ) AND (o.created_at between '2013-04-12' AND '2013-04-19')) ")
      #numero_orientaciones = Orientacion.count(:especialista_id, :joins => "orientacions, tramites t, estatus e", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in ('comp-conc', 'no-compar') AND (orientacions.especialista_id = ? ) AND (orientacions.created_at between ? AND ?)", self.id, seven_days_ago, now])
      #return numero_orientaciones
      num_orientaciones_periodo(seven_days_ago, now)
  end

def num_orientaciones_dos_dias
    now = Date.today + 1
    two_days_ago = (now - 2)
    num_orientaciones_periodo(two_days_ago, now)
  end




  def estatus_actual
    # Buscamos si tienen movimientos o baja
    @baja = (self.situacion == Situacion.find_by_descripcion("BAJA"))? true : nil
    @estatus_actual = (@baja) ? "BAJA" : nil

    # Buscamos si tiene algun otro movimiento
    @movimiento = Movimiento.find(:first, :conditions => ["user_id = ? AND (? between fecha_inicio AND fecha_fin)", self.id, Time.now], :order => "fecha_fin DESC")
    @estatus_actual ||= (@movimiento.situacion)? @movimiento.situacion.descripcion : nil if @movimiento
    puts("=> Movimiento encontrado: #{@movimiento.situacion.descripcion}") if @movimiento && @movimiento.situacion

    #### Buscamos si tiene sesion ahora mismo o proxima dentro de algunos min ####
    if self.has_role?("especialistas")
      total_minutos_anticipacion=21
      minutos_aproximados_sesion=55
      @sesiones_del_dia = Sesion.find(:all, :select => "id, cancel, hora, minutos, horario_id, sala_id, fecha", :conditions => ["(cancel IS NULL or cancel=0) AND fecha= ? AND (mediador_id = ? OR comediador_id = ?) AND hora >= ?", Time.now.strftime("%Y-%m-%d"), self.id, self.id, Time.now.strftime("%H").to_i - 1], :order => "hora,minutos")
      puts "Encuentra sesiones del dia: #{@sesiones_del_dia.size} sesiones" unless @sesiones_del_dia.empty?
      @tiempo_actual = DateTime.civil(Time.now.year, Time.now.month, Time.now.day, Time.now.hour, Time.now.strftime('%M').to_i) unless @sesiones_del_dia.empty?
      @sesiones_del_dia.each do |s|
               if s.start_at
                    puts("Hora de sesion: #{s.start_at.strftime("%d-%m-%Y - %H:%M:%S")}")

                    ## En sesion ahora mismo ###
                    unless s.canceled?
                      if ((s.start_at  <= @tiempo_actual)) && (@tiempo_actual <= (s.start_at + ((minutos_aproximados_sesion/60.0)/(24.0))))
                        @estatus_actual ||= "EN SESION"
                      end
                    end

                     #### Sesion proxima ####
                     if ((s.start_at - ((total_minutos_anticipacion/60.0)/(24.0))) <= @tiempo_actual) && (@tiempo_actual <= (s.start_at - ((1/60.0)/(24.0))))
                        puts("Limite inferior #{(s.start_at - ((total_minutos_anticipacion/60.0)/(24.0)))}")
                        puts("Limite El tiempo ahora #{@tiempo_actual}")
                        puts("Limite superior #{(s.start_at - ((1/60.0)/(24.0)))}")
                        @estatus_actual ||= "SESION PROXIMA (#{s.hora_completa})"
                    end
               end
          end
      end
    @estatus_actual ||= "DISPONIBLE"
    return @estatus_actual
  end



   def disponible?(date=Time.now)
        fecha = (date) ? date.strftime('%Y-%m-%d %H:%M:%S') : Time.now.strftime('%Y-%m-%d %H:%M:%S')
        u = User.count(:id, :conditions => ["id = ? AND id not in (select user_id as id from movimientos where ('#{fecha}' BETWEEN fecha_inicio AND fecha_fin))", self.id])
        return ((u > 0)? true : false)
   end

    protected
      def make_activation_code
            self.activation_code = self.class.make_token
      end

      def default_subdireccion
        self.update_attributes!(:subdireccion_id => 1) unless self.subdireccion
      end

      
  
end
