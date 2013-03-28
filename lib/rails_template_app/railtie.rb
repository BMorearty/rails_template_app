module RailsTemplateApp
  class Railtie < Rails::Railtie
    config.rails_template_app = ActiveSupport::OrderedOptions.new
  end
end