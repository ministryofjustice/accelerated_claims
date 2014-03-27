ENV["RAILS_ENV"] ||= 'test'
ENV["PDFTK"] ||= `which pdftk`.strip
ENV["ANONYMOUS_PLACEHOLDER_EMAIL"] ||= 'anon@example.com'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
    :phantomjs_options => ['--ignore-ssl-errors=yes'],
    :phantomjs_logger => open('/dev/null')
  )
end

Capybara.javascript_driver = :poltergeist

# remote_hosts = {
#   'local' => 'http://civilclaims.local',
#   'demo'  => 'http://civilclaims.dsd.io',
#   'staging' => 'http://civilclaimsstaging.dsd.io',
#   'production' => 'http://civilclaims.service.dsd.io'
# }

if remote = ENV.has_key?('remote_host')
  Capybara.run_server = false
  Capybara.app_host = ENV['remote_host']
  Capybara.default_driver = Capybara.javascript_driver
  WebMock.disable! if defined? WebMock
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding :remote unless remote
  #config.filter_run_excluding :js => false if remote

  config.order = 'random'
end


def form_date field, date
  {
    "#{field}(3i)" => date.try(:day),
    "#{field}(2i)" => date.try(:month),
    "#{field}(1i)" => date.try(:year)
  }
end

def load_stringified_hash_from_file(filename)
  path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))
  contents = IO.read(File.join(path, filename)) 
  data = recursively_stringify_keys(eval contents)
  data
end

def recursively_stringify_keys(hash)
  op = {}
  hash.each do |k, v|
    if v.class == Hash
      hash[k] = recursively_stringify_keys(v)
    end
    op[k.to_s] = hash.delete(k)
  end
  op
end

def load_fixture_data(dataset_number)
  filename = "scenario_#{dataset_number}_data.rb"
  load_stringified_hash_from_file(filename)
end

def load_expected_data(dataset_number)
  filename = "scenario_#{dataset_number}_results.rb"
  load_stringified_hash_from_file(filename)
end
