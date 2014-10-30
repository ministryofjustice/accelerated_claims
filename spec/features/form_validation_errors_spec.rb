# -*- coding: utf-8 -*-
feature 'Filling in claim form' do

  before do
    WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/])
  end

   def check_focus_after_click link_text, selector
    expect(page).to have_content(link_text)
    expect(page).to have_css('div#javascript_done')
    click_link link_text
    active_element = page.evaluate_script('document.activeElement.id')
    expect(active_element).to eq(selector)
  end

  unless remote_test?
    scenario "submitting incomplete form", js: false do
      visit '/'
      click_button 'Continue'
      expect(page).to have_content("Enter the property address")
      expect(page).to have_content("Enter the name of the person who gave the notice")

      expect(page).to have_content("You must say how the notice was given")

      expect(page).to have_content("Please select what kind of property it is")
    end

    scenario "submitting an incomplete deposit information given date", js: true do
      visit '/'
      choose('claim_deposit_received_yes')
      check('claim_deposit_as_money')
      fill_in('claim_deposit_ref_number', with: 'ABC123')
      fill_in('claim_deposit_information_given_date_2i', with: '7')
      fill_in('claim_deposit_information_given_date_1i', with: '14')
      click_button 'Continue'

      expect(page).to have_selector('#claim_deposit_information_given_date_error')
      expect(find_field('claim_deposit_ref_number').value).to eq('ABC123')
      expect(find_field('claim_deposit_information_given_date_3i').value).to eq('')
      expect(find_field('claim_deposit_information_given_date_2i').value).to eq('7')
      expect(find_field('claim_deposit_information_given_date_1i').value).to eq('2014')
    end

    scenario "submitting incomplete form", js: true do
      visit '/'
      click_button 'Continue'

      expect(page).to have_content('Please select what kind of claimant you are')

      check_focus_after_click 'You must say whether the defendant paid a deposit', 'claim_deposit_received_yes'
      check_focus_after_click 'You must choose whether you wish to attend the possible court hearing', 'claim_possession_hearing_no'
      check_focus_after_click 'You must say what kind of tenancy agreement you have', 'claim_tenancy_tenancy_type_assured'

      click_button 'Continue'
    end


    scenario 'clicking on the error message takes you to section', js: true do
      visit '/'
      choose('claim_claimant_type_individual')
      click_button 'Continue'
      expect(page).to have_content('Please say how many claimants there are')

      check_focus_after_click 'Please say how many claimants there are', 'claim_num_claimants'
      check_focus_after_click 'Please enter a valid number of defendants between 1 and 20', 'claim_num_defendants'

      check_focus_after_click 'Please select what kind of property it is', 'claim_property_house_yes'
      check_focus_after_click 'Enter the property address', 'claim_property_street'
      check_focus_after_click 'You must say whether or not you gave notice to the defendant', 'claim_notice_notice_served_yes'

      check_focus_after_click 'You must say whether or not you have an HMO licence', 'claim_license_multiple_occupation_yes'
      check_focus_after_click 'You must say whether the defendant paid a deposit', 'claim_deposit_received_yes'
      check_focus_after_click 'You must choose whether you wish to attend the possible court hearing', 'claim_possession_hearing_no'
      check_focus_after_click 'You must say what kind of tenancy agreement you have', 'claim_tenancy_tenancy_type_assured'

      click_button 'Continue'

      choose('claim_notice_notice_served_no')
      expect(page).to have_content('You cannot continue with this claim')
      click_button 'Continue'
      check_focus_after_click 'You must have given 2 months notice to make an accelerated possession claim', 'claim_notice_notice_served_yes'
    end
  end

  scenario "submitting form without notice checked, the hidden errors should not be shown", js: true do
    visit '/'
    click_button 'Continue'

    expect(page).to have_content('You must say whether or not you gave notice to the defendant')

    expect(page).to have_css('div#javascript_done')
    expect(page).not_to have_content('Enter the name of the person who gave the notice')
    expect(page).not_to have_content('You must say how the notice was given')
    expect(page).not_to have_content('Enter the date notice was served')
    expect(page).not_to have_content('Enter the date notice ended')
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

    expect(page).to have_content("Carefully read the statements below:")
    click_button 'Continue'
    check_focus_after_click 'Please read the statements and tick if they apply', 'claim_tenancy_confirmed_first_rules_period_applicable_statements'

    check_focus_after_click 'You must say who told the defendant about their tenancy agreement', 'claim_tenancy_assured_shorthold_tenancy_notice_served_by'
    check_focus_after_click 'You must say when the defendant was told about their tenancy agreement', 'claim_tenancy_assured_shorthold_tenancy_notice_served_date_3i'

    check('claim_tenancy_confirmed_first_rules_period_applicable_statements')
    click_button 'Continue'

    check_focus_after_click 'You must say who told the defendant about their tenancy agreement', 'claim_tenancy_assured_shorthold_tenancy_notice_served_by'
    check_focus_after_click 'You must say when the defendant was told about their tenancy agreement', 'claim_tenancy_assured_shorthold_tenancy_notice_served_date_3i'
  end

  scenario 'tenancy start_date on or after 28 February 1997', js: true do
    visit '/'
    choose('claim_tenancy_tenancy_type_assured')
    choose('claim_tenancy_assured_shorthold_tenancy_type_one')
    select_tenancy_start_date Tenancy::RULES_CHANGE_DATE

    expect(page).to_not have_content("The tenancy agreement was for 6 months (or more)")
    expect(page).to have_content("You didn’t tell the defendant that the agreement was likely to change")

    expect(page).to have_content("Carefully read the statements below:")
    click_button 'Continue'
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

  scenario 'user specifies 2 claimants but doesnt provide details', js: true do
    visit '/'
    choose 'A private landlord (individual)'

    fill_in 'How many claimants are there?', with: '2'
    click_button 'Continue'

    check_focus_after_click "You must specify whether claimant 2's address is the same as the first claimant",
      'claim_claimant_2_address_same_as_first_claimant_yes'
  end

  context 'address validation' do
    context 'javascript enabled' do

      scenario 'property address with too many lines', js: true do
        visit '/'
        expect(page).not_to have_content(address_js_error_message)
        click_link 'claim_property_postcode_picker_manual_link'
        fill_in('claim_property_street', with: invalid_address)
        expect(page).to have_content(address_js_error_message)
      end

      scenario 'claimant 1 address with valid address', js: true do
        visit '/'
        expect(page).not_to have_content(address_js_error_message)
        choose('claim_claimant_type_individual')
        fill_in('claim_num_claimants', with: '4')
        click_link 'claim_claimant_1_postcode_picker_manual_link'
        fill_in('claim_claimant_1_street', with: valid_address)
        expect(page).not_to have_content(address_js_error_message)
      end

      scenario 'claimant 1 address with invalid address', js: true do
        visit '/'
        expect(page).not_to have_content(address_js_error_message)
        choose('claim_claimant_type_individual')
        fill_in('claim_num_claimants', with: '4')
        click_link 'claim_claimant_1_postcode_picker_manual_link'
        fill_in('claim_claimant_1_street', with: invalid_address)
        expect(page).to have_content(address_js_error_message)
      end

      scenario 'claimant 4 address invalid', js: true do
        visit '/'
        expect(page).not_to have_content(address_js_error_message)
        choose('claim_claimant_type_individual')
        fill_in('claim_num_claimants', with: '4')
        click_link 'claim_claimant_1_postcode_picker_manual_link'
        fill_in('claim_claimant_1_street', with: valid_address)

        choose('claim_claimant_2_address_same_as_first_claimant_no')
        click_link 'claim_claimant_2_postcode_picker_manual_link'
        fill_in('claim_claimant_2_street', with: valid_address)

        choose('claim_claimant_3_address_same_as_first_claimant_no')
        click_link 'claim_claimant_3_postcode_picker_manual_link'
        fill_in('claim_claimant_3_street', with: valid_address)

        choose('claim_claimant_4_address_same_as_first_claimant_no')
        click_link 'claim_claimant_4_postcode_picker_manual_link'
        fill_in('claim_claimant_4_street', with: invalid_address)

        expect(page).not_to have_content(invalid_address)
        expect(page).to have_content(address_js_error_message)
      end

      scenario 'claimant_contact_address valid', js: true do
        visit '/'
        choose('claim_claimant_type_individual')
        fill_in 'claim_num_claimants', with: 1
        click_link 'Add alternative address'
        click_link 'claim_claimant_contact_postcode_picker_manual_link'
        fill_in('claim_claimant_contact_street', with: valid_address)
        expect(page).not_to have_content(address_js_error_message)
      end

      scenario 'claimant_contact_address invalid', js: true do
        visit '/'
        choose('claim_claimant_type_individual')
        fill_in 'claim_num_claimants', with: 1
        click_link 'Add alternative address'
        click_link 'claim_claimant_contact_postcode_picker_manual_link'
        fill_in('claim_claimant_contact_street', with: invalid_address)
        expect(page).to have_content(address_js_error_message)
      end

      scenario 'defendant 1 address valid', js: true do
        visit '/'
        fill_in 'claim_num_defendants', with: 1
        click_link 'defendant_1_resident_details'
        click_link 'claim_defendant_1_postcode_picker_manual_link'
        fill_in 'claim_defendant_1_street', with: valid_address
        expect(page).not_to have_content(address_js_error_message)
      end

      scenario 'defendant 1 address invalid', js: true do
        visit '/'
        fill_in 'claim_num_defendants', with: 1
        click_link 'defendant_1_resident_details'
        click_link 'claim_defendant_1_postcode_picker_manual_link'
        fill_in 'claim_defendant_1_street', with: invalid_address
        expect(page).to have_content(address_js_error_message)
      end

      scenario 'defendant 19 address invalid', js: true do
        visit '/'
        fill_in 'claim_num_defendants', with: 20
        click_link 'defendant_19_resident_details'
        click_link 'claim_defendant_19_postcode_picker_manual_link'
        fill_in 'claim_defendant_19_street', with: invalid_address
        expect(page).to have_content(address_js_error_message)
      end
    end

    context 'javascript disabled' do
      unless remote_test?
        scenario 'property address is invalid' do
          visit '/'
          fill_in('claim_property_street', with: invalid_address)
          click_button 'Continue'
          expect(page).to have_content( non_js_address_error_message('Property') )
        end

        scenario 'claimant_1 address is invalid' do
          visit '/'
          choose 'claim_claimant_type_individual'
          fill_in 'claim_num_claimants', with: '1'
          fill_in('claim_claimant_1_street', with: invalid_address)
          click_button 'Continue'
          expect(page).to have_content( non_js_address_error_message("Claimant 1's") )
        end

        scenario 'claimant_4 address is invalid' do
          visit '/'
          choose 'claim_claimant_type_individual'
          fill_in 'claim_num_claimants', with: '4'
          fill_in('claim_claimant_4_street', with: invalid_address)
          click_button 'Continue'
          expect(page).to have_content( non_js_address_error_message("Claimant 4's") )
        end

        scenario 'claimant contact address is invalid' do
          visit '/'
          fill_in('claim_claimant_contact_street', with: invalid_address)
          click_button 'Continue'
          expect(page).to have_content( non_js_address_error_message("Claimant contact's") )
        end

        scenario 'defendant_1 address is invalid' do
          visit '/'
          fill_in('claim_num_defendants', with: '1')
          fill_in('claim_defendant_1_street', with: invalid_address)
          click_button 'Continue'
          expect(page).to have_content( non_js_address_error_message("Defendant 1's") )
        end
      end
    end
  end
end

def invalid_address
  "line 1\nline 2\nline 3\nline 4\nline 5\n"
end

def valid_address
  "line 1\nline 2\nline 3\nline 4"
end

def address_js_error_message
  "The address can’t be longer than 4 lines."
end

def non_js_address_error_message(attribute)
  "#{attribute} address can’t be longer than 4 lines."
end
