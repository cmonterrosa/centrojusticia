# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
#config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false
SITE_URL = "ceja.poderjudicialchiapas.gob.mx"
NOMBRE_OFICIAL="Centro Estatal de Justicia Alternativa Chiapas"
MAGISTRADO_PRESIDENTE="MAGDO. RUTILIO ESCANDON CADENAS"
CODIGO_SEGURIDAD="x1234567890"
REPORTS_DIR = "#{RAILS_ROOT}/app/reports"
SITE_URL = "ceja.poderjudicialchiapas.gob.mx"
HORAS_ATENCION=["8", "9", "10", "11", "14", "15", "16", "17", "18", "19", "20"]
DIAS_ATENCION = {1 => "Lunes", 2 => "Martes", 3 => "Miércoles", 4 => "Jueves", 5=> "Viernes"}
