require 'capybara/rails'
require 'capybara/rspec'

class Capybara::Session
  # like current_path but includes the query string
  def current_fullpath
    uri = URI.parse(current_url)
    uri.query.blank? ? uri.path : "#{uri.path}?#{uri.query}"
  end
end

module CapybaraExtensions
  delegate :current_fullpath, to: :page
end
