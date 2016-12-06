require 'capybara-webkit'

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
end

FileUtils.rm_rf(Dir['/tmp/pdf*pdf'])
