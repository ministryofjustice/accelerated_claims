feature 'Filling in property section' do

  before do
    WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/])
    allow_any_instance_of(Courtfinder::Client::HousingPossession).to \
      receive(:get).and_return(court_address)
  end

  unless remote_test?
    scenario "see room number hint", js: false do
      visit '/'
      expect(page).to have_content('If "Room or rooms in a property" was selected above, include the room number')
    end

    scenario "selecting room in a property, then selecting self-contained house", js: true do

      visit '/'
      wait_for_ajax
      expect(page).to have_css('div#javascript_done')
      expect(page).not_to have_content('Include the room number')
      choose('claim_property_house_no')

      fill_in 'claim_property_postcode_edit_field', with: 'rg28pu'
      click_link 'Find address'
      wait_for_ajax
      select "160 Northumberland Avenue, READING", from: "sel-address"
      click_link "claim_property_selectaddress"
      expect(page).to have_content('Include the room number')

      choose('claim_property_house_yes')
      expect(page).not_to have_content('Include the room number')

      choose('claim_property_house_no')
      expect(page).to have_content('Include the room number')
    end
  end
end
