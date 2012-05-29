# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_centrojusticia_session',
  :secret      => 'eb9a18d4de884ae54c3114aae77242002cf06999f2d494e9f0cf383e847b5085ce5114ccfdf0b2eb1269e98e8558024222cc12003f758366396c17fc21689388'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
