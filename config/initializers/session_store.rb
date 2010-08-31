# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_js-tests_session',
  :secret      => '0c01c444f5177f81650ec6977ae06609b5eff77f78ad89fffc833379274cc1a53155247b9e05018fcdc8ed3f10caf03e77005e80f695931dd9d8f019cd23403b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
