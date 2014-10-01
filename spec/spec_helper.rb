# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl'

module Benchmark
  class Tms
    quietly do
      FORMAT = "%17n %10.6u %10.6y %10.6t %10.6r\n"
    end
  end
end

module BM
  def bm(label, &block)
    puts Benchmark.measure(label) { block.call }
  end
end

# Load support files and factories
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # Adds login_user(user=@user)) and logout_user helpers.  Only for use in functional tests.
  config.include Sorcery::TestHelpers::Rails::Controller, type: :controller
  config.include Sorcery::TestHelpers::Rails::Integration, type: :feature
  config.include RequestSpecHelpers, type: :request
  config.include CapybaraExtensions
  config.include Capybara::DSL, type: :request
  config.include BM

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before :each do |example|
    desc = example.full_description
    Rails.logger.debug "\n#{desc}\n#{'-' * desc.length}\n"
  end

  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end
end
