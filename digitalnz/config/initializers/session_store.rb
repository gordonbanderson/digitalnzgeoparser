# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_digitalnz_session',
  :secret      => 'e7ab8907b0d18a40623a312785465698e4123a111b973bda667a41a6307ad283734b55de30399fac34022dd4259b0030d38f75cc59d5a8826566aa66356146cf'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
