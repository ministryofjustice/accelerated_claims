# -*- coding: utf-8 -*-
feature 'Filling in claim form' do

  before do
    WebMock.disable_net_connect!(:allow => "127.0.0.1")
  end

  unless remote_test?
    scenario "submitting incomplete form", js: false do
      visit '/'
      click_button 'Complete form'
      expect(page).to have_content("Enter the full address")

      expect(page).to have_content("Enter the name of the person who gave the notice")

      expect(page).to have_content("You must say how the notice was given")

      expect(page).to have_content("Please select what kind of property it is")
    end
  end

  def check_focus_after_click link_text, selector
    click_link link_text
    expect(page.evaluate_script('document.activeElement.id')).to eq(selector)
  end

  scenario "submitting incomplete form", js: true do
    visit '/'
    click_button 'Complete form'

    expect(page).to have_content('Please select what kind of claimant you are')

    expect(page).to have_selector('input#claim_order_possession')
    expect(page).to have_selector(:xpath, '//label[@for="claim_order_possession"]')

    check_focus_after_click 'You must say whether the defendant paid a deposit', 'claim_deposit_received_yes'
    check_focus_after_click 'You must choose whether you wish to attend the possible court hearing', 'claim_possession_hearing_no'
    check_focus_after_click 'Please tick to confirm that you want to repossess the property', 'claim_order_possession'
    check_focus_after_click 'You must say what kind of tenancy agreement you have', 'claim_tenancy_tenancy_type_assured'

    click_button 'Complete form'
  end

  scenario "submitting form with only claimant type selected", js: true do
    visit '/'
    choose('claim_claimant_type_individual')
    click_button 'Complete form'

    expect(page).to have_content('Please say how many claimants there are')

    expect(page).to have_selector('input#claim_order_possession')
    expect(page).to have_selector(:xpath, '//label[@for="claim_order_possession"]')

    check_focus_after_click 'Please say how many claimants there are', 'claim_num_claimants_1'
    check_focus_after_click 'Please say how many defendants there are', 'claim_num_defendants_1'

    check_focus_after_click 'Please select what kind of property it is', 'claim_property_house_yes'
    check_focus_after_click 'Enter the full address', 'claim_property_street'
    check_focus_after_click 'Enter the postcode', 'claim_property_postcode'

    check_focus_after_click 'You must say whether or not you gave notice to the defendant', 'claim_notice_notice_served_yes'

    check_focus_after_click 'You must say whether or not you have an HMO licence', 'claim_license_multiple_occupation_yes'
    check_focus_after_click 'You must say whether the defendant paid a deposit', 'claim_deposit_received_yes'
    check_focus_after_click 'You must choose whether you wish to attend the possible court hearing', 'claim_possession_hearing_no'
    check_focus_after_click 'Please tick to confirm that you want to repossess the property', 'claim_order_possession'
    check_focus_after_click 'You must say what kind of tenancy agreement you have', 'claim_tenancy_tenancy_type_assured'

    choose('claim_num_claimants_1')
    choose('claim_num_defendants_1')
    choose('claim_defendant_one_inhabits_property_yes')
    choose('claim_notice_notice_served_yes')

    fill_in('claim_claimant_one_title', with: 'Major')
    fill_in('claim_claimant_one_full_name', with: 'Tom')

    click_button 'Complete form'

    unless remote_test?
      expect(find_field('claim_claimant_one_title').value).to eq('Major')
      expect(find_field('claim_claimant_one_full_name').value).to eq('Tom')
    end

    check_focus_after_click 'Enter the name of the person who gave the notice', 'claim_notice_served_by_name'
    check_focus_after_click 'You must say how the notice was given', 'claim_notice_served_method'
    check_focus_after_click 'Enter the date notice was served', 'claim_notice_date_served_3i'
    check_focus_after_click 'Enter the date notice ended', 'claim_notice_expiry_date_3i'

    choose('claim_notice_notice_served_no')

    expect(page).to have_content('You cannot continue with this claim')

    click_button 'Complete form'

    check_focus_after_click 'You must say whether or not you gave notice to the defendant', 'claim_notice_notice_served_yes'
  end

  def select_tenancy_start_date date
    day = date.day.to_s
    month = Date::MONTHNAMES[date.month]
    year = date.year.to_s

    fill_in("claim_tenancy_start_date_3i", with: day)
    fill_in("claim_tenancy_start_date_2i", with: month)
    fill_in("claim_tenancy_start_date_1i", with: year)
  end

  scenario 'tenancy starting before first rules period', js: true do
    visit '/'
    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_assured_shorthold_tenancy_type_one')
    select_tenancy_start_date(Tenancy::APPLICABLE_FROM_DATE - 1)

    expect(page).to_not have_content("You didn’t tell the defendant that the agreement was likely to change")
    expect(page).to_not have_content("The tenancy agreement was for 6 months (or more)")
  end

  scenario 'tenancy starting in first rules period', js: true do
    visit '/'
    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_assured_shorthold_tenancy_type_one')
    select_tenancy_start_date Tenancy::APPLICABLE_FROM_DATE

    expect(page).to_not have_content("You didn’t tell the defendant that the agreement was likely to change")
    expect(page).to have_content("The tenancy agreement was for 6 months (or more)")

    expect(page).to have_content("Carefully read the statements below:")
    click_button 'Complete form'
    check_focus_after_click 'Please read the statements and tick if they apply', 'claim_tenancy_confirmed_first_rules_period_applicable_statements'

    expect(page).to_not have_content('You must say who told the defendant about their tenancy agreement')
    expect(page).to_not have_content('You must say when the defendant was told about their tenancy agreement')

    check('claim_tenancy_confirmed_first_rules_period_applicable_statements')
    click_button 'Complete form'

    check_focus_after_click 'You must say who told the defendant about their tenancy agreement', 'claim_tenancy_assured_shorthold_tenancy_notice_served_by'
    check_focus_after_click 'You must say when the defendant was told about their tenancy agreement', 'claim_tenancy_assured_shorthold_tenancy_notice_served_date_3i'
  end

  scenario 'tenancy starting in second rules period', js: true do
    visit '/'
    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_assured_shorthold_tenancy_type_one')
    select_tenancy_start_date Tenancy::RULES_CHANGE_DATE

    expect(page).to_not have_content("The tenancy agreement was for 6 months (or more)")
    expect(page).to have_content("You didn’t tell the defendant that the agreement was likely to change")

    expect(page).to have_content("Carefully read the statements below:")
    click_button 'Complete form'
    check_focus_after_click 'Please read the statements and tick if they apply', 'claim_tenancy_confirmed_second_rules_period_applicable_statements'
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
