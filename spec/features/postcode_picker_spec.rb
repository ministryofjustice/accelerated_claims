# -*- coding: utf-8 -*-
feature 'Postcode address lookup' do

  before do
    WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/])
  end

  scenario "service unavailable results in manual address entry", js: true do
    visit '/'
    fill_in 'claim_property_postcode_edit_field', with: 'SW1 9AB' # 9 triggers service unavailable response
    click_link 'Find UK Postcode'

    expect(page).to have_content("Postcode lookup service not available. Please enter the address manually.")
    fill_in 'claim_property_street', with: "2 Smith Street\nREADING"
    fill_in 'claim_property_postcode', with: "RG2 7PU"
  end

  scenario "enter postcode and select address from list", js: true do
    visit '/'
    fill_in 'claim_property_postcode_edit_field', with: 'SW10 6GG'
    click_link 'Find UK Postcode'

    select "5 Melbury Close, FERNDOWN", from: "sel-address"
    click_link "claim_propery_selectaddress"

    expect(page).to have_field('claim_property_postcode', with: "BH22 8HR")
    expect(page).to have_field('claim_property_street', with: "5 Melbury Close\nFERNDOWN")
  end

end
