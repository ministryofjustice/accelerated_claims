# -*- coding: utf-8 -*-
feature 'Filling in claim form' do

  before do
    WebMock.disable_net_connect!(:allow => "127.0.0.1")
  end

  unless remote_test?
    scenario "submitting incomplete form", js: false do
      visit '/'
      click_button 'Complete form'
      expect(page).to have_content("Street must be entered")

      expect(page).to have_content("Served by name must be entered")

      expect(page).to have_content("Served method must be entered")

      expect(page).to have_content("House must be selected")
    end
  end

  def check_focus_after_click link_text, selector
    click_link link_text
    expect(page.evaluate_script('document.activeElement.id')).to eq(selector)
  end

  scenario "submitting incomplete form", js: true do
    visit '/'
    click_button 'Complete form'

    expect(page).to have_content('Number of claimants must be entered')

    check_focus_after_click 'Number of claimants must be entered', 'claim_num_claimants_1'
    check_focus_after_click 'Number of defendants must be entered', 'claim_num_defendants_1'

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

    choose('claim_num_claimants_1')
    choose('claim_num_defendants_1')
    choose('claim_defendant_one_inhabit_property_yes')


    fill_in('claim_claimant_one_title', with: 'Major')
    fill_in('claim_claimant_one_full_name', with: 'Tom')

    click_button 'Complete form'

    unless remote_test?
      expect(find_field('claim_claimant_one_title').value).to eq('Major')
      expect(find_field('claim_claimant_one_full_name').value).to eq('Tom')
    end
    
  end

  def select_tenancy_start_date date
    day = date.day.to_s
    month = Date::MONTHNAMES[date.month]
    year = date.year.to_s

    fill_in("claim_tenancy_start_date_3i", with: day)
    fill_in("claim_tenancy_start_date_2i", with: month)
    fill_in("claim_tenancy_start_date_1i", with: year)
  end

  scenario 'tenancy start_date before 15 January 1989', js: true do
    visit '/'
    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_assured_shorthold_tenancy_type_one')
    select_tenancy_start_date(Tenancy::APPLICABLE_FROM_DATE - 1)

    expect(page).to_not have_content("You didn’t tell the defendant that the agreement was likely to change")
    expect(page).to_not have_content("The tenancy agreement was for 6 months (or more)")
  end

  scenario 'tenancy start_date between 15 January 1989 and 27 February 1997', js: true do
    visit '/'
    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_assured_shorthold_tenancy_type_one')
    select_tenancy_start_date Tenancy::APPLICABLE_FROM_DATE

    expect(page).to have_content("Carefully read the statements below:")
    expect(page).to_not have_content("You didn’t tell the defendant that the agreement was likely to change")
    expect(page).to have_content("The tenancy agreement was for 6 months (or more)")
  end

  scenario 'tenancy start_date on or after 28 February 1997', js: true do
    visit '/'
    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_assured_shorthold_tenancy_type_one')
    select_tenancy_start_date Tenancy::RULES_CHANGE_DATE

    expect(page).to_not have_content("The tenancy agreement was for 6 months (or more)")
    expect(page).to have_content("You didn’t tell the defendant that the agreement was likely to change")
  end

  scenario 'user checks deposit checkboxes then changes mind to no deposit', js: true do
    visit '/'
    choose('claim_deposit_received_yes')
    check('claim_deposit_as_money')
    expect(page).to have_content("you kept the deposit in a government-backed deposit protection scheme and met the scheme’s requirements")

    check('claim_deposit_as_property')
    expect(page).to have_content("it had been returned at the time notice was given")

    choose('claim_deposit_received_no')
    expect(page).to_not have_content("you kept the deposit in a government-backed deposit protection scheme and met the scheme’s requirements")
    expect(page).to_not have_content("it had been returned at the time notice was given")

    choose('claim_deposit_received_yes')
    expect(page.has_no_checked_field?('claim_deposit_as_money')).to eq(true)
    expect(page.has_no_checked_field?('claim_deposit_as_property')).to eq(true)
  end

end
