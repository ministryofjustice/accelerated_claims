# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

if Rails.env.test?
  require 'ci/reporter/rake/rspec'
end

AcceleratedClaims::Application.load_tasks

