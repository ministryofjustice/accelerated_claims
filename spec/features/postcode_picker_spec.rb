# -*- coding: utf-8 -*-

feature 'Postcode address lookup' do

  before do
    WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/])
  end

  def click_find_address
    within(:xpath, '/html/body//div[@id="property"]') do
      click_link 'Find address'
    end
  end

  if remote_test?
    context 'live lookup' do
      scenario "enter postcode and select address from list", js: true do
        load_page
        fill_in 'claim_property_postcode_edit_field', with: 'BH22 8HR'
        click_find_address

        select "Catwalk Cafe, 18 Montpellier Parade, HARROGATE", from: "sel-address"
        click_link "claim_property_selectaddress"

        expect(page).to have_field('claim_property_postcode', with: "HG1 2TG")
        expect(page).to have_field('claim_property_street', with: "Catwalk Cafe\n18 Montpellier Parade\nHARROGATE")
      end

    end
  else
    context 'normal usage' do
      scenario "enter postcode and select address from list", js: true do
        load_page
        fill_in 'claim_property_postcode_edit_field', with: 'SW10 6GG'
        click_find_address

        select "5 Melbury Close, FERNDOWN", from: "sel-address"
        click_link "claim_property_selectaddress"

        expect(page).to have_field('claim_property_postcode', with: "BH22 8HR")
        expect(page).to have_field('claim_property_street', with: "5 Melbury Close\nFERNDOWN")
      end

      scenario 'search successfully then search different postcode results in new results', js: true do
        load_page
        fill_in 'claim_property_postcode_edit_field', with: 'SW10 6GG'
        click_find_address

        select "5 Melbury Close, FERNDOWN", from: "sel-address"
        click_link 'claim_property-manual_change-link-2'
        fill_in 'claim_property_postcode_edit_field', with: 'SW10 5GG'
        click_find_address

        select "50 Tregunter Road, LONDON", from: "sel-address"
        click_link 'claim_property_selectaddress'
        expect(page).to have_field('claim_property_street', with: "50 Tregunter Road\nLONDON")
      end

      scenario 'enter and select postcode and then click change link hides address and moves focus to edit box', js: true do
        load_page
        fill_in 'claim_property_postcode_edit_field', with: 'rg27pu'
        click_find_address

        select "156 Northumberland Avenue, READING", from: "sel-address"
        click_link "claim_property_selectaddress"

        click_link 'Change'
        expect(page).to have_field('claim_property_postcode_edit_field')
        expect(page).not_to have_field('claim_property_street')
      end

      scenario 'selecting a postcode hides the postcode entry box and find button', js: true do
        load_page
        fill_in 'claim_property_postcode_edit_field', with: 'rg27pu'
        click_find_address

        select "156 Northumberland Avenue, READING", from: "sel-address"
        click_link "claim_property_selectaddress"

        expect(page).not_to have_field('claim_property_postcode_edit_field')
      end
    end

    context 'error messages' do
      scenario "service unavailable results in manual address entry", js: true do
        load_page
        fill_in 'claim_property_postcode_edit_field', with: 'SW1 9AB' # 9 triggers service unavailable response
        click_find_address

        expect(page).to have_content("Postcode lookup service not available. Please enter the address manually.")
        fill_in 'claim_property_street', with: "2 Smith Street\nREADING"
        fill_in 'claim_property_postcode', with: "RG2 7PU"
      end

      scenario "search for postcode no addresses found opens for manual edit", js: true do
        load_page
        fill_in 'claim_property_postcode_edit_field', with: 'SW10 0GG' # 0 trigger no results found
        click_find_address

        expect(page).to have_content('No address found. Please enter the address manually')
        expect(page).to have_field('claim_property_postcode_edit_field')
      end

      scenario 'search successfully, then search resulting in error hides select list', js: true do
        load_page
        fill_in 'claim_property_postcode_edit_field', with: 'SW10 6GG'
        click_find_address

        click_link 'claim_property-manual_change-link-2'
        fill_in 'claim_property_postcode_edit_field', with: 'SW10 0GG' # 0 trigger no results found
        click_find_address

        expect(page).not_to have_field('sel-address')
      end

      scenario 'select an address and then enter another address with no results and edit box should be empty', js: true do
        load_page
        fill_in 'claim_property_postcode_edit_field', with: 'rg27pu'
        click_find_address

        select "160 Northumberland Avenue, READING", from: "sel-address"
        click_link "claim_property_selectaddress"
        click_link 'Change'
        fill_in 'claim_property_postcode_edit_field', with: 'sw109lb'
        click_find_address

        expect(page).to have_content("Postcode lookup service not available. Please enter the address manually.")
        expect(page).to have_field('claim_property_street', with: '')
        expect(page).to have_field('claim_property_postcode', with: '')
      end
    end

    context 'manual entry' do
      scenario "choose and do manual address entry", js: true do
        load_page
        click_link 'Enter address manually'

        fill_in 'claim_property_street', with: "2 Smith Street\nREADING"
        fill_in 'claim_property_postcode', with: "RG2 7PU"
      end

      scenario "choose and do manual address entry then toggle manual address closed", js: true do
        load_page
        click_link 'Enter address manually'

        fill_in 'claim_property_street', with: "5 Melbury Close\nFERNDOWN"
        fill_in 'claim_property_postcode', with: "BH22 8HR"

        click_link 'Enter address manually'

        expect(page).not_to have_field('claim_property_postcode', with: "BH22 8HR")
        expect(page).not_to have_field('claim_property_street', with: "5 Melbury Close\nFERNDOWN")
      end

      scenario "click manual edit and then search for postcode", js: true do
        load_page
        click_link 'Enter address manually'

        fill_in 'claim_property_postcode_edit_field', with: 'SW10 6GG'
        click_find_address

        expect(page).not_to have_field('claim_property_postcode')
        expect(page).not_to have_field('claim_property_street')
      end
    end
  end
end

def load_page
  visit '/'
  expect(page).to have_css('div#javascript_done')
end

