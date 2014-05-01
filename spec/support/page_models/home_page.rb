class HomePage
  include Capybara::DSL

  def visit
    Capybara.visit '/'
  end

  def start_claim
    page.has_text?('Start now')
    click_link 'Start now'
  end
end