class HomePage
  include Capybara::DSL

  def visit
    Capybara.visit '/'
  end
end
