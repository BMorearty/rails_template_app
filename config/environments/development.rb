Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.rails_template_app.host = "localhost"
  config.rails_template_app.port = 3000

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise an error if the mailer can't send
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    user_name:            ENV['SMTP_USERNAME'] || 'do-not-reply@railstemplateapp.com',
    password:             ENV['SMTP_PASSWORD'] || 'super-secret password for rails_template_app',
    authentication:       :login,
    enable_starttls_auto: true
  }
  config.action_mailer.default_url_options =
    { host: config.rails_template_app.host, port: config.rails_template_app.port }
  config.roadie.url_options =
    { host: config.rails_template_app.host, port: config.rails_template_app.port }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # BCrypt security level.  1 is fast, 10 is secure.
  config.rails_template_app.sorcery_bcrypt_cost = 10
end
