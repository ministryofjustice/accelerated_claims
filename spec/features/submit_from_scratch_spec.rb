feature 'new submit claim', js: true do

  before do
    WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/])
    allow_any_instance_of(Courtfinder::Client::HousingPossession).to receive(:get).and_return(court_address)
    Capybara.current_driver = :selenium
    Selenium::WebDriver::Firefox::Binary.path='/usr/local/bin/firefox/firefox-bin'
  end

  after do
    Capybara.use_default_driver
  end

  scenario 'submit' do
    visit '/'
    expect(page).to have_content 'Evict a tenant using accelerated possession'
    click_button 'Continue'
    sleep 1
    expect(page).to have_content 'You need to fix the errors on this page before continuing'
    choose :claim_property_house_yes
    fill_in :claim_property_street, with: 'A street/nlondon'
    fill_in :claim_property_postcode, with: 'SW1H 9AJ'
    choose :claim_claimant_type_individual
    fill_in :claim_num_claimants, with: 1
    fill_in :claim_claimant_1_title, with: 'Mr'
    fill_in :claim_claimant_1_full_name, with: 'John Smith'
    click_link :claim_claimant_1_postcode_picker_manual_link
    fill_in :claim_claimant_1_street, with: 'My House'
    fill_in :claim_claimant_1_postcode, with: 'AB12CD'
    fill_in :claim_num_defendants, with: 1
    fill_in :claim_defendant_1_title, with: 'Mr'
    fill_in :claim_defendant_1_full_name, with: 'John Smith'

    choose :claim_notice_notice_served_yes
    fill_in :claim_notice_served_by_name, with: 'served  by'
    fill_in :claim_notice_served_method, with: 'in person'
    fill_in :claim_notice_date_served_3i, with: '1'
    fill_in :claim_notice_date_served_2i, with: '1'
    fill_in :claim_notice_date_served_1i, with: '2016'
    fill_in :claim_notice_expiry_date_3i, with: '1'
    fill_in :claim_notice_expiry_date_2i, with: '3'
    fill_in :claim_notice_expiry_date_1i, with: '2016'

    choose :claim_tenancy_tenancy_type_assured
    choose :claim_tenancy_assured_shorthold_tenancy_type_one
    fill_in :claim_tenancy_start_date_3i, with: '1'
    fill_in :claim_tenancy_start_date_2i, with: '3'
    fill_in :claim_tenancy_start_date_1i, with: '2015'

    check :claim_tenancy_confirmed_second_rules_period_applicable_statements

    choose :claim_license_multiple_occupation_no
    choose :claim_deposit_received_no
    choose :claim_order_cost_no
    choose :claim_possession_hearing_no
    fill_in :claim_court_court_name, with: 'court'
    fill_in :claim_court_street, with: 'street'


    click_button 'Continue'
    sleep 1
    click_link :download
    sleep 5
    puts page
    expect(page).not_to have_content 'pdftk'
  end
end
