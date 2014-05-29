class HomePage
  include Capybara::DSL

  def visit
    Capybara.visit '/?anim=false'
  end
end
