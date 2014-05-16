feature 'Filling in claim form' do

  before do
    WebMock.disable_net_connect!(:allow => "127.0.0.1")
  end

  unless remote_test?
    scenario "submitting incomplete form", js: false do
      visit '/new'
      click_button 'Complete form'
      expect(page).to have_content("Street must be entered")

      expect(page).to have_content("Served by name must be entered")

      expect(page).to have_content("Served method must be entered")

      expect(page).to have_content("House must be selected")
    end
  end

  def check_focus_after_click link_text, selector
    click_link link_text
    page.evaluate_script('document.activeElement.id').should == selector
  end

  scenario "submitting incomplete form", js: true do
    visit '/new'
    click_button 'Complete form'

    check_focus_after_click 'Question "As the landlord, you’re known as the claimant in this case. How many claimants are there?" not answered', 'multiplePanelRadio_claimants_1'
    check_focus_after_click 'Question "Your tenants are known as defendants in this case. How many defendants are there?" not answered', 'multiplePanelRadio_defendants_1'

    check_focus_after_click 'House must be selected', 'claim_property_house_yes'
    check_focus_after_click 'Street must be entered', 'claim_property_street'
    check_focus_after_click 'Postcode must be entered', 'claim_property_postcode'

    check_focus_after_click 'Served by name must be entered', 'claim_notice_served_by_name'
    check_focus_after_click 'Served method must be entered', 'claim_notice_served_method'
    check_focus_after_click 'Date served must be entered', 'claim_notice_date_served_3i'
    check_focus_after_click 'Expiry date must be entered', 'claim_notice_expiry_date_3i'
    check_focus_after_click 'Multiple occupation must be selected', 'claim_license_multiple_occupation_yes'
    check_focus_after_click 'Received must be selected', 'claim_deposit_received_yes'
    check_focus_after_click 'Hearing must be selected', 'claim_possession_hearing_no'
    check_focus_after_click 'Possession must be checked', 'claim_order_possession'
    check_focus_after_click 'Tenancy type must be selected', 'claim_tenancy_tenancy_type_assured'

    choose('multiplePanelRadio_claimants_1')
    choose('multiplePanelRadio_defendants_1')
    choose('multiplePanelRadio_defendants_1')
    choose('defendant1address-yes')

    fill_in('claim_claimant_one_title', with: 'Major')
    fill_in('claim_claimant_one_full_name', with: 'Tom')

    click_button 'Complete form'

    find_field('claim_claimant_one_title').value.should == 'Major'
    find_field('claim_claimant_one_full_name').value.should == 'Tom'
  end

end
