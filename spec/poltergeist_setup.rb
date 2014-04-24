require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
    :phantomjs_options => ['--ignore-ssl-errors=yes', '--ssl-protocol=tlsv1'],
    :phantomjs_logger => open('/dev/null')
  )
end

Capybara.javascript_driver = :poltergeist
