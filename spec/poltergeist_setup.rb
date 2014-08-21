require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
    :timeout => 60,
    :phantomjs_options => ['--ignore-ssl-errors=yes']
    # :phantomjs_logger => open('/dev/null')
  )
end

Capybara.javascript_driver = :poltergeist
