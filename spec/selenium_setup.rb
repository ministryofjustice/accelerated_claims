Capybara.register_driver :selenium do |app|
  browser = ENV['browser']
  if browser && [:chrome, :safari, :firefox].include?(browser.to_sym)
    browser = browser.to_sym
  else
    browser = :chrome
  end
#   Capybara::Selenium::Driver.new(app, browser: browser)
# end

  profile = Selenium::WebDriver::Firefox::Profile.new
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.timeout = 120 # instead of the default 60
  opts = {
      "args": ['--no-remote'],
      "prefs": {
          "dom.ipc.processCount": '8'
      },
      "log": {
          "level": 'trace',
          "file": '/tmp/geckodriver.log'
      }
  }
  caps = Selenium::WebDriver::Remote::Capabilities.firefox(firefox_options: opts)
  Capybara::Selenium::Driver.new(app, browser: :firefox, profile: profile, http_client: client, browser: browser, desired_capabilities: caps)
end

Capybara.javascript_driver = :selenium
Capybara.default_driver = Capybara.javascript_driver

