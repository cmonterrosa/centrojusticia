# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!

SITE_URL = "ceja.poderjudicialchiapas.gob.mx"
NOMBRE_OFICIAL="Centro Estatal de Justicia Alternativa Chiapas"
MAGISTRADO_PRESIDENTE="MAGDO. JUAN ÓSCAR TRINIDAD PALACIOS"
HORAS_ATENCION=["8", "9", "10", "11", "14", "15", "16", "17", "18", "19", "20"]
DIAS_ATENCION = {1 => "Lunes", 2 => "Martes", 3 => "Miércoles", 4 => "Jueves", 5=> "Viernes"}
CODIGO_SEGURIDAD="x1234567890"
REPORTS_DIR = "#{RAILS_ROOT}/app/reports"
SUBDIRECCION="DIRECCION GENERAL"
LUGAR="CHIAPA DE CORZO"
HABILITADO_RESERVA_SESION=false