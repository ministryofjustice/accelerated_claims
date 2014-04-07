ENV["RAILS_ENV"] ||= 'test'
ENV["PDFTK"] ||= `which pdftk`.strip
ENV["ANONYMOUS_PLACEHOLDER_EMAIL"] ||= 'anon@example.com'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'

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
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding :remote unless remote_test?
  #config.filter_run_excluding :js => false if remote_test?

  config.order = 'random'
  config.include ShowMeTheCookies, type: :feature
end

