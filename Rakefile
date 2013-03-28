#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'resque/tasks'
require File.expand_path('../config/application', __FILE__)

RailsTemplateApp::Application.load_tasks

# https://github.com/defunkt/resque/issues/433
# http://stackoverflow.com/questions/7807733/resque-worker-failing-with-postgresql-server/7846127#7846127
task "resque:setup" => :environment do
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
end
