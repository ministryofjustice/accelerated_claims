ENV["RAILS_ENV"] ||= 'test'
ENV["PDFTK"] ||= `which pdftk`.strip
ENV["ANONYMOUS_PLACEHOLDER_EMAIL"] ||= 'anon@example.com'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'webmock/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

if ENV['BS_USERNAME']
  require_relative 'remote_test_setup' # for now browserstack always remote test
  require_relative 'browserstack_setup'
elsif ENV['browser']
  require_relative 'selenium_setup'
  require_relative 'remote_test_setup' if remote_test?
else
  require_relative 'poltergeist_setup'
  require_relative 'remote_test_setup' if remote_test?
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding :remote unless remote_test?
  #config.filter_run_excluding :js => false if remote_test?

  config.order = 'random'
  config.include ShowMeTheCookies, type: :feature

  config.infer_spec_type_from_file_location!
end

def diffmerge(actual, expected)
  home = ENV['HOME']
  File.open(File.join(home, 'tmp', 'actual.html'), 'w') do |fp|
    fp.print actual
  end
  File.open(File.join(home, 'tmp', 'expected.html'), 'w') do |fp|
    fp.print expected
  end
  puts "**** HTML written to actual.html and expected.html in #{home}/tmp for comparison in diffmerge"
end
