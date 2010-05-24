# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_InstaDelish_session',
  :secret      => '56e81cf7efc05c1c343fc5097dba0e5e6144451d163998f4bc1b92a5573840e056d3a05d74c695f9e3b8d630f4c88c0fd3c13ce3ba1b4d0b45791a3eb88254a1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
