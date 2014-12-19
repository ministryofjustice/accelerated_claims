feature 'Tenancy' do
  before do
    WebMock.disable_net_connect!(allow: ['127.0.0.1', /codeclimate.com/])
  end

  before(:each) do
    visit '/'
    choose('claim_notice_notice_served_yes')
  end

  scenario 'Start date of tenancy should be 01/01/this year', js: true do
    expected_date = Date.new(Date.today.year - 1, 3, 1).strftime('%d %m %Y')
    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_assured_shorthold_tenancy_type_one')
    test_displayed_value('Start date of the tenancy agreement', expected_date)
  end

  scenario 'Date notice served should be 01/01/this year', js: true do
    expected_date = Date.new(Date.today.year, 1, 1).strftime('%d %m %Y')
    test_displayed_value('Date notice served', expected_date)
  end

  scenario 'Date notice ended should be 01/03/this year', js: true do
    expected_date = Date.new(Date.today.year, 3, 1).strftime('%d %m %Y')
    test_displayed_value('Date notice ended', expected_date)
  end

  def test_displayed_value(text, value)
    xpath_src =  "//fieldset[contains(./legend/text(), '#{text}')]//span"
    control = find(:xpath, xpath_src).text
    expect(control).to eql("For example, #{value}")
  end

end
