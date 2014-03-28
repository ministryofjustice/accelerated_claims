class HomePage
  include Capybara::DSL
  
  def to_s
    '/'
  end

  def start_claim
    click_link 'Start now'
  end
end