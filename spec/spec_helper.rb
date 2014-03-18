ENV["RAILS_ENV"] ||= 'test'
ENV["PDFTK"] ||= '/usr/local/bin/pdftk'
ENV["ANONYMOUS_PLACEHOLDER_EMAIL"] ||= 'anon@example.com'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'

require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end

Capybara.javascript_driver = :poltergeist

if ENV.has_key? 'remote_host'
  Capybara.app_host = ENV['remote_host']
  Capybara.default_driver = Capybara.javascript_driver
  WebMock.disable!
  RSpec.configure { |c| c.filter_run_excluding :js => false }
end

def form_date field, date
  {
    "#{field}(3i)" => date.try(:day),
    "#{field}(2i)" => date.try(:month),
    "#{field}(1i)" => date.try(:year)
  }
end
