feature 'new submit claim', js: true do

  before do
    WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/])
    allow_any_instance_of(Courtfinder::Client::HousingPossession).to receive(:get).and_return(court_address)

  end

  scenario 'submit' do
    visit '/'
    expect(page).to have_content 'Evict a tenant using accelerated possession'
    click_button 'Continue'
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
    click_button 'Continue'
    expect(page).to have_content 'You need to fix the errors on this page before continuing'

    fill_in :claim_num_defendants, with: 1
    fill_in :claim_claimant_1_title, with: 'Mr'
    fill_in :claim_claimant_1_full_name, with: 'John Smith'
    click_link :claim_claimant_1_postcode_picker_manual_link
    fill_in :claim_claimant_1_street, with: 'My House'
    fill_in :claim_claimant_1_postcode, with: 'AB12CD'

    fill_in :xxx, with: 'yyy'
    fill_in :xxx, with: 'yyy'
  end
end
