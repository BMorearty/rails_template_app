source 'https://rubygems.org'

gem 'rails'
gem 'pg'
gem 'haml', '>= 3.0.0'
gem 'haml-rails'
gem 'jquery-rails'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'sorcery'
gem 'andand'
gem 'resque'
gem 'thin'
gem 'newrelic_rpm'
gem 'rest-client'
gem 'jbuilder'
gem 'dalli'
gem 'roadie'
gem 'roadie-rails'
#gem 'rack-mini-profiler' - disable for now, since it prevents Rack::ConditionalGet from returning 304 Not Changed.
gem 'resque_mail_queue'
gem 'turbolinks'
gem 'jquery-turbolinks'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails' #,   '~> 3.2.3'
  gem 'coffee-rails' #, '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails'
end

group :development, :test do
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'capybara'
  gem 'rspec-rails', '>= 2.0.1'
  gem 'looksee'
  gem 'guard'
  gem 'guard-rspec'
  gem 'awesome_print'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'whiny_validation'
  gem 'timecop'
end

group :development do
  gem 'rails-footnotes'
  gem 'bullet'
  gem 'better_errors'
end

group :test do
  gem 'resque_spec'
end
