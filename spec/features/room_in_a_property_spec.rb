# -*- coding: utf-8 -*-
feature 'Filling in property section' do

  before do
    WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/])
  end

  
  pending "wait for postcode picker to be finished before re-enabling" do

    unless remote_test?
      scenario "see room number hint", js: false do
        visit '/'
        expect(page).to have_content('If "Room(s) in a property" was selected above, include the room number')
      end
  
      scenario "see room number hint", js: false do
        visit '/'
        expect(page).to have_content('If "Room or rooms in a property" was selected above, include the room number')
      end

      scenario "selecting room in a property, then selecting self-contained house", js: true do
        visit '/'
        expect(page).not_to have_content('Include the room number')

        choose('claim_property_house_no')
        expect(page).to have_content('Include the room number')

        choose('claim_property_house_yes')
        expect(page).not_to have_content('Include the room number')

        choose('claim_property_house_no')
        expect(page).to have_content('Include the room number')
      end

      scenario "selecting room in a property and submitting", js: true do
        visit '/'
        choose('claim_property_house_no')
        expect(page).to have_content('Include the room number')

        click_button 'Continue'
        expect(page).to have_content('Enter the full address')
        expect(page).to have_content('Include the room number')
      end
    end
  end
end
