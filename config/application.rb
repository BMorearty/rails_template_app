require File.expand_path('../boot', __FILE__)

require 'rails/all'
require_relative "../lib/rails_template_app/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsTemplateApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.assets.enabled = true

    # BMorearty make Heroku work. https://devcenter.heroku.com/articles/rails3x-asset-pipeline-cedar
    config.assets.initialize_on_precompile = false

    # Put each third-party library in its own directory under vendor/assets
    config.assets.paths << Rails.root.join("vendor", "assets")

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end

    config.cache_store = :dalli_store
  end
end
