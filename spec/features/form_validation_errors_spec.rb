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

  def select_tenancy_start_date date
    day = date.day
    month = Date::MONTHNAMES[date.month]
    year = date.year

    select(  day, :from => "claim_tenancy_start_date_3i")
    select(month, :from => "claim_tenancy_start_date_2i")
    select( year, :from => "claim_tenancy_start_date_1i")
  end

  scenario 'tenancy start_date before 15 January 1989', js: true do
    visit '/new'
    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_assured_shorthold_tenancy_type_one')
    select_tenancy_start_date(Tenancy::APPLICABLE_FROM_DATE - 1)

    expect(page).to_not have_content("You didn’t tell the defendant that the agreement was likely to change")
    expect(page).to_not have_content("The tenancy agreement was for 6 months (or more)")
  end

  scenario 'tenancy start_date between 15 January 1989 and 27 February 1997', js: true do
    visit '/new'
    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_assured_shorthold_tenancy_type_one')
    select_tenancy_start_date Tenancy::APPLICABLE_FROM_DATE

    expect(page).to have_content("Read the statements below and select all that apply:")
    expect(page).to_not have_content("You didn’t tell the defendant that the agreement was likely to change")
    expect(page).to have_content("The tenancy agreement was for 6 months (or more)")
  end

  scenario 'tenancy start_date on or after 28 February 1997', js: true do
    visit '/new'
    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_assured_shorthold_tenancy_type_one')
    select_tenancy_start_date Tenancy::RULES_CHANGE_DATE

    expect(page).to_not have_content("The tenancy agreement was for 6 months (or more)")
    expect(page).to have_content("You didn’t tell the defendant that the agreement was likely to change")
  end

end
