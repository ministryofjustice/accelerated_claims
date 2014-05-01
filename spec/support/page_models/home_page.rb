class HomePage
  include Capybara::DSL

  def visit
    Capybara.visit '/'
  end

  def start_claim
    click_link 'Start now'
  end
end