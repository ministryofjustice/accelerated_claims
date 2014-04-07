Capybara.register_driver :selenium do |app|
  browser = ENV['browser']
  if browser && [:chrome, :safari, :firefox].include?(browser.to_sym)
    browser = browser.to_sym
  else
    browser = :chrome
  end
  Capybara::Selenium::Driver.new(app, browser: browser)
end

Capybara.javascript_driver = :selenium

