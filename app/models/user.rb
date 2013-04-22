require 'digest/sha1'
require 'date'

class User < ActiveRecord::Base
  
  
  has_many :comparecencias
  has_many :participantes
  has_many :tramites
  has_many :orientacions
  # ---------------------------------------
  # The following code has been generated by role_requirement.
  # You may wish to modify it to suit your need
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :materias
  belongs_to :subdireccion
  
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

  before_save :default_subdireccion
  before_create :make_activation_code 

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :paterno, :materno, :nombre, :direccion, :activo, :tel_celular, :last_login, :categoria, :num_orientaciones_por_semana, :full_description_for_especialistas


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
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL and activo=true', login] # need to get the salt
    u && u.authenticated?(password) && u.update_attributes!(:last_login => Time.now) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def nombre_completo
    "#{self.nombre.strip} #{self.paterno.strip} #{self.materno.strip}"
  end

  def full_description_for_especialistas
     "#{self.nombre.strip} #{self.paterno.strip} #{self.materno.strip}"
     # "#{self.nombre.strip} #{self.paterno.strip} #{self.materno.strip} | #{num_orientaciones_por_semana} Orientaciones"
  end

  def num_orientaciones_por_semana
      now = Date.today
      seven_days_ago = (now - 7)
      #numero_orientaciones = Orientacion.find_by_sql("SELECT count(o.especialista_id) AS count_especialista_id FROM `orientacions` o, tramites t, estatus e WHERE (o.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in ('comp-conc', 'no-compar') AND (o.especialista_id = 10 ) AND (o.created_at between '2013-04-12' AND '2013-04-19')) ")
      #numero_orientaciones = Orientacion.count(:especialista_id, :joins => "orientacions, tramites t, estatus e", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in ('comp-conc', 'no-compar') AND (orientacions.especialista_id = ? ) AND (orientacions.created_at between ? AND ?)", self.id, seven_days_ago, now])
      #return numero_orientaciones
      num_orientaciones_periodo(seven_days_ago, now)
  end

  def num_orientaciones_periodo(inicio,fin)
      numero_orientaciones = Orientacion.count(:especialista_id, :joins => "orientacions, tramites t, estatus e", :conditions => ["orientacions.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in ('comp-conc', 'no-compar') AND (orientacions.especialista_id = ? ) AND (orientacions.created_at between ? AND ?)", self.id, inicio, fin])
      return numero_orientaciones
  end

    protected
      def make_activation_code
            self.activation_code = self.class.make_token
      end

      def default_subdireccion
        self.subdireccion_id = (self.subdireccion_id) ? self.subdireccion_id : 1
      end
  
end
