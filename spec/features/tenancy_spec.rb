feature 'Tenancy' do
  before do
    WebMock.disable_net_connect!(allow: ['127.0.0.1', /codeclimate.com/])
  end

  before(:each) do
    visit '/'
    choose('claim_notice_notice_served_yes')
  end

  scenario 'start date should be 01/01/this year', js: true do
    expected_date = Date.new(Date.today.year - 1, 3, 1).strftime('%d %m %Y')
    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_assured_shorthold_tenancy_type_one')
    test_displayed_value('Start date of the tenancy agreement', expected_date)
  end

  scenario 'notice served date should be 01/01/this year', js: true do
    expected_date = Date.new(Date.today.year, 1, 1).strftime('%d %m %Y')
    test_displayed_value('Date notice served', expected_date)
  end

  scenario 'notice ended date should be 01/03/this year', js: true do
    expected_date = Date.new(Date.today.year, 3, 1).strftime('%d %m %Y')
    test_displayed_value('Date notice ended', expected_date)
  end

  scenario 'date of original tenancy should be 01/03/Year-2 ', js: true do
    check_text = 'Date of the original tenancy agreement'
    expected_date = Date.new(Date.today.year - 2, 3, 1).strftime('%d %m %Y')

    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_assured_shorthold_tenancy_type_multiple')

    test_displayed_value(check_text, expected_date)
  end

  scenario 'start date should be 01/01/this year', js: true do
    check_text = 'Date of the most recent tenancy agreement'
    expected_date = Date.new(Date.today.year - 1, 3, 1).strftime('%d %m %Y')

    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_assured_shorthold_tenancy_type_multiple')

    test_displayed_value(check_text, expected_date)
  end

  def test_displayed_value(text, value)
    xpath_src =  "//fieldset[contains(./legend/text(), '#{text}')]//span"
    control = find(:xpath, xpath_src).text
    expect(control).to eql("For example, #{value}")
  end
end
