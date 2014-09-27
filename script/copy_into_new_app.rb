#!/usr/bin/env ruby
#
# rails_template_app/script/copy_into_new_app APP_NAME

require 'pathname'
require 'active_support/core_ext/string/inflections'
require 'fileutils'
require 'securerandom'

def say(msg)
  puts "=== #{msg}"
end

def app_name
  ARGV[0]
end

def app_name_no_underscores
  @app_name_no_underscores ||= app_name.gsub('_','')
end

def app_name_camelcase
  @app_name_camelcase ||= app_name.camelcase
end

def dir_name
  ARGV[1] || app_name
end

def source_dir
  @source_dir ||= Pathname(File.dirname(__FILE__)).parent.to_s
end

def usage
  puts "usage: rails_template_app/script/copy_into_new_app APP_NAME [DIR_NAME] [DOMAIN]"
  puts
  puts "       Run from the parent directory of rails_template_app."
  puts "       APP_NAME, DIR_NAME, and DOMAIN should be all lower case."
  puts "       The new app will be created in a folder at the same level as rails_template_app."
  puts "       Default DIR_NAME is the same as APP_NAME."
  puts "       Default DOMAIN is APPNAME.com (underscores removed)."
  puts
  puts "examples:"
  puts "       rails_template_app/script/copy_into_new_app awesome_app"
  puts "         # app name is awesome_app/AwesomeApp,   dir name is awesome_app,   domain is awesomeapp.com"
  puts "       rails_template_app/script/copy_into_new_app great_app greatapp"
  puts "         # app name is great_app/GreatApp,       dir name is greatapp,      domain is greatapp.com"
  puts "       rails_template_app/script/copy_into_new_app awesome_app awesomeapp helloworld.com"
  puts "         # app name is awesome_app/AwesomeApp,   dir name is awesomeapp,    domain is helloworld.com"
  exit
end

def copy_files(from, to)
  say "Copying files"
  print `cp -r #{from} #{to}`
  FileUtils.rm_rf "#{to}/.git"
  FileUtils.rm_rf "#{to}/.idea"
  FileUtils.rm "#{to}/script/copy_into_new_app.rb"
end

def maybe_rename_file(filename)
  if filename =~ /rails_template_app/
    new_name = filename.gsub("rails_template_app", app_name)
    File.rename filename, new_name
    new_name
  else
    filename
  end
end

def rename_app_in_file(filename)
  print `LANG=C sed -i '' 's/RailsTemplateApp/#{app_name_camelcase}/g' #{filename}`
  print `LANG=C sed -i '' 's/rails_template_app/#{app_name}/g' #{filename}`
  print `LANG=C sed -i '' 's/railstemplateapp/#{app_name_no_underscores}/g' #{filename}`
end

def rename_app_in_dir(dir)
  Dir.chdir dir
  Dir.foreach('.') do |filename|
    next if %w(. ..).include?(filename)
    filename = maybe_rename_file(filename)
    if File.directory?(filename)
      rename_app_in_dir(filename)
    else
      rename_app_in_file(filename)
    end
  end
ensure
  Dir.chdir '..'
end

def rename_app
  say "Renaming:"
  puts "  RailsTemplateApp   => #{app_name_camelcase}"
  puts "  rails_template_app => #{app_name}"
  puts "  railstemplateapp   => #{app_name_no_underscores}"
  rename_app_in_dir(dir_name)
end

def create_db_user
  say "Creating DB user"
  print `psql -U brian template1 -c 'create role #{app_name_no_underscores} createdb login'`
end

def bundle
  say "bundle install"
  print `bundle install`
end

def create_db
  say "rake db:create"
  print `bundle exec rake db:create`
end

# db/schema.rb exists in the original app so I can things in there.
# It needs to be reset in the copy.
def remove_db_schema
  say "Removing db/schema.rb"
  FileUtils.rm "db/schema.rb"
end

def generate_secret
  say "Generating app secret"
  filename = "config/secrets.yml"
  contents = File.read(filename).gsub('this secret token will be replaced', SecureRandom.hex(128))
  File.write filename, contents
end

# Mailer is disabled in the template so I can test changes without pushing a password
# to the public template repo.
def enable_mailer_for_development
  say "Enabling mailer for development"
  filename = "config/environments/development.rb"
  contents = File.read(filename).gsub('config.action_mailer.perform_deliveries = false', 'config.action_mailer.perform_deliveries = true')
  File.write filename, contents
end

usage unless app_name && app_name.downcase == app_name
say "Generating app #{app_name} in #{Dir.pwd}/#{dir_name}"
copy_files(source_dir, dir_name)
rename_app
Dir.chdir(dir_name)
create_db_user
bundle
create_db
remove_db_schema
generate_secret
enable_mailer_for_development
say "Done."
