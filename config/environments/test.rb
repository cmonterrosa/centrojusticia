# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# Use SQL instead of Active Record's schema dumper when creating the test database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql


SITE_URL = "ceja.poderjudicialchiapas.gob.mx"
NOMBRE_OFICIAL="Centro Estatal de Justicia Alternativa Chiapas"
MAGISTRADO_PRESIDENTE="MAGDO. RUTILIO ESCANDÓN CADENAS"
HORAS_ATENCION=["8", "9", "10", "11", "14", "15", "16", "17", "18", "19", "20"]
DIAS_ATENCION = {1 => "Lunes", 2 => "Martes", 3 => "Miércoles", 4 => "Jueves", 5=> "Viernes"}
CODIGO_SEGURIDAD="x1234567890"
REPORTS_DIR = "#{RAILS_ROOT}/app/reports"