AcceleratedClaims::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # in memory cache store
  config.cache_store = :memory_store

  # or if we want to use redis in development, comment out the line above
  # and uncomment the line below, and modify config/initialisers/session_store.rb to treat dev the
  # same as production.
  #
  # config.cache_store = :redis_store, ('redis://localhost:6379/1')

  jsonlogger = LogStuff.new_logger("#{Rails.root}/log/output.json", Logger::INFO)

  config.log_level = :info
  config.logstasher.enabled = true
  config.logstasher.suppress_app_log = false
  config.logstasher.logger = jsonlogger

  # Need to specifically set the logstasher loglevel since it will overwrite the one set earlier
  config.logstasher.log_level = Logger::INFO
  config.logstasher.source = "accelerated_claims.development.#{ENV['USER']}"
  # Reuse logstasher logger with logstuff
  LogStuff.setup(:logger => jsonlogger)

end
