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

# Capybara.javascript_driver = :poltergeist
Capybara.run_server = true
Capybara.server_port = 9887

if remote = ENV.has_key?('remote_host')
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

def values_from_pdf file
  fields = `pdftk #{file} dump_data_fields`
  fields.strip.split('---').each_with_object({}) do |fieldset, hash|
    field = fieldset[/FieldName: ([^\s]+)/,1]
    value = fieldset[/FieldValue: (.+)/,1]
    value.gsub!('&#13;',"\n") if value.present?
    hash[field] = value if field.present?
  end
end

def load_fixture_data(dataset_number)
  path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))
  filename = "scenario_#{dataset_number}_data.rb"
  contents = IO.read(File.join(path, filename)) 
  data = eval(contents).stringify_keys
  data['claim'].keys.each do |k| 
    data['claim'][k].keys.each { |sk| data['claim'][k][sk.to_s] = data['claim'][k].delete(sk) }
    data['claim'][k.to_s] = data['claim'].delete(k); 
  end
  data
end
