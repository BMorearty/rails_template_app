module RailsTemplateApp
  class Railtie < Rails::Railtie
    # TODO: is this still needed?
    config.rails_template_app = ActiveSupport::OrderedOptions.new
  end
end