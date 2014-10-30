require 'nokogiri'

class ClaimForm
  include Capybara::DSL

  def initialize(data)
    @data = data
  end

  def complete_form
    @js_on = false
    fill_property_details
    claimant_type = select_claimant_type
    if claimant_type == 'individual'
      select_number_of_claimants
      fill_claimant(1, use_javascript: false)
      fill_claimant(2, use_javascript: false)
      fill_claimant(3, use_javascript: false)
      fill_claimant(4, use_javascript: false)
    else
      fill_organizational_claimant
    end

    select_number_of_defendants
    fill_in_defendant(1, complete_address: true)
    fill_in_defendant(2, complete_address: true)
    fill_claimant_contact
    fill_tenancy
    fill_notice
    fill_licences
    fill_deposit
    fill_postponement
    choose_defendant_pay_costs
    fill_court_fee
    fill_fee_account
    fill_legal_costs
    fill_reference_number
  end

  def complete_form_with_javascript
    @js_on = true
    claimant_type = select_claimant_type
    fill_property_details

    if claimant_type == 'individual'
      number_of_claimants = select_number_of_claimants
      (1 .. number_of_claimants.to_i).each do |claimant_id|
        fill_claimant(claimant_id)
      end
    else
      fill_organizational_claimant
    end

    number_of_defendants = select_number_of_defendants
    (1 .. number_of_defendants.to_i).each do |i|
      address_to_be_completed = choose_defendant_living_in_property(i)           # selects the defendent living in property yes/no button according to the data
      fill_in_defendant(i, complete_address: address_to_be_completed)
    end

    fill_claimant_contact_with_js

    fill_tenancy
    fill_notice
    fill_licences
    fill_deposit
    fill_postponement
    choose_defendant_pay_costs
    fill_court_fee
    fill_legal_costs
    fill_reference_number_with_js unless claimant_type == 'individual'
    fill_fee_account_with_js
  end

  def select_number_of_claimants
    num_claimants = get_data('claim', 'num_claimants')
    find_it('input', 'claim_num_claimants').set(num_claimants)
    num_claimants
  end

  def select_number_of_defendants
    num_defendants = get_data('claim', 'num_defendants')
    find_it('input', 'claim_num_defendants').set(num_defendants)
    num_defendants
  end

  def choose_claimant_2_address_the_same
    case get_data('javascript','claimant_2_same_address')
    when 'Yes'
      choose('claimant2address-yes')
    else
      choose('claimant2address-no')
    end
  end

  def choose_defendant_living_in_property(index)
    address_to_be_completed = nil
    defendant = "defendant_#{index}"
    case get_data(defendant, "inhabits_property")
    when 'Yes'
      choose("claim_defendant_#{index}_inhabits_property_yes")
      address_to_be_completed = false
    else
      choose("claim_defendant_#{index}_inhabits_property_no")
      address_to_be_completed = true
    end
    address_to_be_completed
  end

  def fill_claimant_contact_with_js
    if get_data('javascript','separate_correspondence_address') == 'Yes'
      find('#correspondence-address').click
      complete_details_of_person('claimant_contact', claimant_contact: true)
      fill_in_text_field('claimant_contact', 'company_name')
    end
    if get_data('javascript','other_contact_details') == 'Yes'
      find('#contact-details').click
      fill_claimant_contact_details
    end
  end

  def fill_claimant_contact
    complete_details_of_person('claimant_contact', js: false)
    fill_in_text_field('claimant_contact', 'company_name')
    fill_claimant_contact_details
  end

  def fill_claimant_contact_details
    prefix = 'claimant_contact'
    fill_in_text_field(prefix, 'email')
    fill_in_text_field(prefix, 'phone')
    fill_in_text_field(prefix, 'fax')
    fill_in_text_field(prefix, 'dx_number')
  end

  def fill_legal_costs
    fill_in_text_field('legal_cost', 'legal_costs')
  end

  def fill_reference_number
    fill_in_text_field_if_present('reference_number', 'reference_number')
  end

  def fill_reference_number_with_js
    unless get_data('reference_number', 'reference_number').blank?
      find('#reference-number').click
      fill_reference_number
    end
  end

  def submit
    submit_claim
  end

  def validation_error_text
    errors = ["Validation Errors:"]
    page.all('.error-summary li').each { |li| errors << "#{li.text}: #{li.find('a')['href']}" }
    errors.join("\n\t")
  end

  def fill_in_value element, id, value
    find_it(element, id).set value
  end

  def fill_in_text_field(prefix, key)
    fill_in_value 'input', "claim_#{prefix}_#{key}", get_data(prefix, key)
  end

  def fill_in_text_area(prefix, key)
    fill_in_value 'textarea', "claim_#{prefix}_#{key}", get_data(prefix, key)
  end

  def fill_in_text_field_if_present(prefix, key)
    unless get_data(prefix, key).blank?
      fill_in_text_field(prefix, key)
    end
  end

  def get_data prefix, key
    begin
      @data['claim'][prefix][key]
    rescue Exception => e
      raise ['no data', prefix, key].join(': ')
    end
  end

  def select_claimant_type
    claimant_type = get_data('claim', 'claimant_type')
    id = "claim_claimant_type_#{claimant_type}"
    find_it('input', id).set(true)
    claimant_type
  end

  def choose_radio(prefix, key)
    if choice = get_data(prefix,key)
      selection = "claim_#{prefix}_#{key}_#{choice}".downcase
      find_it('input', selection).set(true)
    end
  end

  def check_box(prefix, key)
    if(get_data(prefix, key).downcase == 'yes')
      find_it('input', "claim_#{prefix}_#{key}").set(true)
    end
  end

  def fill_in_moj_date_fieldset(prefix, key)
    data = get_data(prefix, key)

    # data expected as three hyphen separated strings in order year month day
    if data =~ /^([0-9]{4})-([0-9A-Za-z]{1,9})-([0-9]{1,2})$/
      day = $3
      month = $2
      year = $1

      fill_in_value 'input', "claim_#{prefix}_#{key}_3i", day
      fill_in_value 'input', "claim_#{prefix}_#{key}_2i", month
      fill_in_value 'input', "claim_#{prefix}_#{key}_1i", year
    end
  end

  def fill_organizational_claimant
    fill_in_text_field('claimant_1', 'organization_name')
    click_manual_address_link('claimant_1')
    fill_in_text_area('claimant_1', 'street')
    fill_in_text_field('claimant_1', 'postcode')
  end

  def complete_details_of_person(prefix, options={})
    options = { complete_address: true }.merge(options)
    fill_in_text_field(prefix, 'title')
    fill_in_text_field(prefix, 'full_name')

    if options[:complete_address]
      click_manual_address_link(prefix) unless options[:claimant_contact] || !@js_on
      fill_in_text_area(prefix, 'street')
      fill_in_text_field(prefix, 'postcode')

    elsif !@js_on && (prefix == 'claimant_2') && get_data('javascript', 'claimant_2_same_address').to_s[/Yes/]
      fill_in_value 'textarea', "claim_claimant_2_street", get_data('claimant_1', 'street')
      fill_in_value 'input',    "claim_claimant_2_postcode", get_data('claimant_1', 'postcode')
    end
  end

  def click_manual_address_link(prefix)
    find_it('a',"claim_#{prefix}_postcode_picker_manual_link").click
  end

  def fill_property_details
    prefix = 'property'
    click_manual_address_link(prefix) unless !@js_on
    fill_in_text_area(prefix, 'street')
    fill_in_text_field(prefix, 'postcode')

    choose_radio(prefix, 'house')
  end

  def fill_claimant(claimant_id, options = {use_javascript: true} )
    claimant_prefix = "claimant_#{claimant_id}"

    fill_in_address = true
    if claimant_id != 1  && options[:use_javascript] == true
      choose_radio claimant_prefix, 'address_same_as_first_claimant'
      fill_in_address = false if get_data(claimant_prefix, 'address_same_as_first_claimant') == 'Yes'
    end
    complete_details_of_person(claimant_prefix, complete_address: fill_in_address)
  end

  def fill_in_defendant(defendant_number, options)
    defendant = "defendant_#{defendant_number}"
    fill_in_text_field(defendant, 'title')
    fill_in_text_field(defendant, 'full_name')
    choose_radio defendant, 'inhabits_property'
    if options[:complete_address] == true
      click_manual_address_link(defendant)
      fill_in_text_area(defendant, 'street')
      fill_in_text_field(defendant, 'postcode')
    end
  end

  def fill_tenancy
    prefix = 'tenancy'
    choose_radio  prefix, 'tenancy_type'

    case get_data(prefix, 'tenancy_type')
    when 'assured'
      choose_radio  prefix, 'assured_shorthold_tenancy_type'

      case get_data(prefix, 'assured_shorthold_tenancy_type')
      when 'one'
        fill_single_tenancy
      when 'multiple'
        fill_multiple_tenancy
      else
        raise 'Unexpected number of tenancy agreements'
      end
    when 'demoted'
      fill_in_moj_date_fieldset prefix, 'demotion_order_date'
      fill_in_text_field prefix, 'demotion_order_court'
      choose_radio  prefix, 'previous_tenancy_type'
    else
      raise 'Unexpected tenancy type'
    end
  end

  def fill_single_tenancy
    prefix      = 'tenancy'
    fill_in_moj_date_fieldset('tenancy', 'start_date')
    start_date  = Date.parse(get_data(prefix, 'start_date'))

    if Tenancy.in_first_rules_period? start_date
      fill_in_text_field prefix, 'assured_shorthold_tenancy_notice_served_by'
      fill_in_moj_date_fieldset prefix, 'assured_shorthold_tenancy_notice_served_date'
    end
    check_box(prefix, 'confirmed_first_rules_period_applicable_statements') if get_data(prefix, 'confirmed_first_rules_period_applicable_statements') == 'Yes'
    check_box(prefix, 'confirmed_second_rules_period_applicable_statements') if get_data(prefix, 'confirmed_second_rules_period_applicable_statements') == 'Yes'
  end

  def fill_multiple_tenancy
    prefix = 'tenancy'
    choose_radio  prefix,'agreement_reissued_for_same_property'
    choose_radio  prefix, 'agreement_reissued_for_same_landlord_and_tenant'
    fill_in_moj_date_fieldset   prefix, 'original_assured_shorthold_tenancy_agreement_date'
    fill_in_moj_date_fieldset prefix, 'latest_agreement_date'
    fill_in_moj_date_fieldset prefix, 'latest_agreement_date'

    start_date = Date.parse(get_data(prefix, 'original_assured_shorthold_tenancy_agreement_date'))
    check_box(prefix, 'confirmed_first_rules_period_applicable_statements') if get_data(prefix, 'confirmed_first_rules_period_applicable_statements') == 'Yes'
    check_box(prefix, 'confirmed_second_rules_period_applicable_statements') if get_data(prefix, 'confirmed_second_rules_period_applicable_statements') == 'Yes'

    if Tenancy.in_first_rules_period? start_date
      fill_in_text_field prefix, 'assured_shorthold_tenancy_notice_served_by'
      fill_in_moj_date_fieldset prefix, 'assured_shorthold_tenancy_notice_served_date'
    end
  end

  def fill_notice
    prefix = 'notice'
    if get_data('notice', 'notice_served') == "Yes"
      choose_radio(prefix, 'notice_served')
    end
    fill_in_text_field(prefix, 'served_by_name')
    fill_in_text_field(prefix, 'served_method')
    fill_in_moj_date_fieldset(prefix, 'date_served')
    fill_in_moj_date_fieldset(prefix, 'expiry_date')
  end

  def fill_licences
    prefix = 'license'
    choose_radio(prefix, 'multiple_occupation')

    case hmo = get_data(prefix, 'multiple_occupation')
      when /Yes/
        case part = get_data(prefix, 'issued_under_act_part_yes')
          when /Part2/
            choose 'claim_license_issued_under_act_part_yes_part2'
          when /Part3/
            choose 'claim_license_issued_under_act_part_yes_part3'
          when nil
          else
            raise part
        end
        fill_in_text_field(prefix, 'issued_by')
        fill_in_moj_date_fieldset prefix, 'issued_date'

      when /Applied/
        case part = get_data(prefix, 'issued_under_act_part_applied')
          when /Part2/
            choose 'claim_license_issued_under_act_part_applied_part2'
          when /Part3/
            choose 'claim_license_issued_under_act_part_applied_part3'
          when nil
          else
            raise part
          end

      when /No/
      when nil
      else
        raise hmo
    end
  end

  def fill_deposit
    prefix = 'deposit'
    choose_radio(prefix,'received')

    if get_data(prefix, 'received') == 'Yes'
      check_box(prefix, 'as_property') if get_data(prefix, 'as_property') == 'Yes'
      if get_data(prefix, 'as_money') == 'Yes'
        check_box(prefix, 'as_money') if get_data(prefix, 'as_money') == 'Yes'
        fill_in_text_field prefix, 'ref_number'
        fill_in_moj_date_fieldset prefix, 'information_given_date'
      end
    end
  end

  def fill_postponement
    choose_radio('possession','hearing')
  end

  def choose_defendant_pay_costs
    choose_radio('order', 'cost')
  end

  def fill_court_fee
    prefix = 'fee'
    # it is hardcoded value for now
    # fill_in_text_field(prefix, 'court_fee')
  end

  def fill_fee_account
    fill_in_text_field('fee', 'account')
  end
  def fill_fee_account_with_js
    if get_data('fee','account') != nil
      find('#fee-account').click
      fill_in_text_field('fee', 'account')
      end
  end

end
