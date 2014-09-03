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
    select_number_of :defendants
    fill_defendant_one complete_address: true
    fill_defendant_two complete_address: true
    fill_claimant_contact
    fill_tenancy
    fill_notice
    fill_licences
    fill_deposit
    fill_postponement
    choose_defendant_pay_costs
    fill_court_fee
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

    number_of_defendants = select_number_of :defendants
    address_to_be_completed = choose_defendant_living_in_property 'one',1           # selects the defendent living in property yes/no button according to the data
    fill_defendant_one complete_address: address_to_be_completed
    if number_of_defendants == 2
      address_to_be_completed = choose_defendant_living_in_property 'two', 2
      fill_defendant_two complete_address: address_to_be_completed
    end

    fill_claimant_contact_with_js

    fill_tenancy
    fill_notice_with_js
    fill_licences
    fill_deposit
    fill_postponement
    choose_defendant_pay_costs
    fill_court_fee
    fill_legal_costs
    fill_reference_number_with_js unless claimant_type == 'individual'
  end

  def select_number_of_claimants
    num_claimants = get_data('claim', 'num_claimants')
    fill_in "How many claimants are there?", with: num_claimants
    num_claimants
  end

  def select_number_of type
    case type
    when :claimants
      button_prefix = "claim_num"
      model = "claim"
    when :defendants
      button_prefix =  "claim_num"
      model = "claim"
    end

    number = get_data(model, "num_#{type}").to_i
    case number
      when 1
        choose("#{button_prefix}_#{type}_1")
      when 2
        choose("#{button_prefix}_#{type}_2")
    end
    find("#claim_#{type.to_s.singularize}_one_title") # wait for selector to be shown
    number
  end



  def choose_claimant_2_address_the_same
    case get_data('javascript','claimant_2_same_address')
    when 'Yes'
      choose('claimant2address-yes')
    else
      choose('claimant2address-no')
    end
  end

  def choose_defendant_living_in_property count, index
    defendant = "defendant_#{count}"
    case get_data(defendant, "inhabits_property")
    when 'Yes'
      choose("claim_defendant_#{count}_inhabits_property_yes")
      address_to_be_completed = false
    else
      choose("claim_defendant_#{count}_inhabits_property_no")
      address_to_be_completed = true
    end
    address_to_be_completed
  end

  def fill_claimant_contact_with_js
    if get_data('javascript','separate_correspondence_address') == 'Yes'
      find('#correspondence-address').click
      complete_details_of_person('claimant_contact')
      fill_in_text_field('claimant_contact', 'company_name')
    end
    if get_data('javascript','other_contact_details') == 'Yes'
      find('#contact-details').click
      fill_claimant_contact_details
    end
  end

  def fill_claimant_contact
    complete_details_of_person('claimant_contact')
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
    click_button 'Continue'
  end

  def validation_error_text
    errors = ["Validation Errors:"]
    page.all('.error-summary li').each { |li| errors << "#{li.text}: #{li.find('a')['href']}" }
    errors.join("\n\t")
  end


  def fill_in_text_field(prefix, key)
    fill_in("claim_#{prefix}_#{key}", with: get_data(prefix, key))
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

  def choose_radio(prefix, key)
    choice = get_data(prefix,key)
    selection = "claim_#{prefix}_#{key}_#{choice}".downcase
    choose(selection) unless choice.nil?
  end

  def check_box(prefix, key)
    if(get_data(prefix, key).downcase == 'yes')
      begin
        check("claim_#{prefix}_#{key}")
      rescue Capybara::ElementNotFound
        check("claim_#{prefix}_#{key}", visible: false)
      end
    end
  end

  def fill_in_moj_date_fieldset(prefix, key)
    data = get_data(prefix, key)

    # data expected as three hyphen separated strings in order year month day
    if data =~ /^([0-9]{4})-([0-9A-Za-z]{1,9})-([0-9]{1,2})$/
      day = $3
      month = $2
      year = $1

      fill_in("claim_#{prefix}_#{key}_3i", with: day)
      fill_in("claim_#{prefix}_#{key}_2i", with: month)
      fill_in("claim_#{prefix}_#{key}_1i", with: year)
    end
  end


  def fill_organizational_claimant
    fill_in_text_field('claimant_1', 'organization_name')
    fill_in_text_field('claimant_1', 'street')
    fill_in_text_field('claimant_1', 'postcode')
  end



  def complete_details_of_person(prefix, options={})
    options = { complete_address: true }.merge(options)
    fill_in_text_field(prefix, 'title')
    fill_in_text_field(prefix, 'full_name')

    if options[:complete_address]
      fill_in_text_field(prefix, 'street')
      fill_in_text_field(prefix, 'postcode')

    elsif !@js_on && (prefix == 'claimant_2') && get_data('javascript', 'claimant_2_same_address').to_s[/Yes/]
      fill_in("claim_claimant_2_street", with: get_data('claimant_1', 'street'))
      fill_in("claim_claimant_2_postcode", with: get_data('claimant_1', 'postcode'))
    end
  end

  def select_claimant_type
    claimant_type = get_data('claim', 'claimant_type')
    choose "claim_claimant_type_#{claimant_type}"
    claimant_type
  end

  def fill_property_details
    prefix = 'property'
    fill_in_text_field(prefix, 'street')
    fill_in_text_field(prefix, 'postcode')

    choose_radio(prefix, 'house')
  end


  def fill_claimant(claimant_id, options = {use_javascript: true} )
    fill_in_address = true
    if claimant_id != 1  && options[:use_javascript] == true
      fill_in_address = get_data('javascript', "claimant_#{claimant_id}_same_address") == 'Yes' ? false : true
      fill_in_address == true ? choose("claimant#{claimant_id}address-no") : choose("claimant#{claimant_id}address-yes")
    end
    complete_details_of_person("claimant_#{claimant_id}", complete_address: fill_in_address)
  end



  def fill_defendant_one(options = {})
    fill_in_defendant('one', options)
  end

  def fill_defendant_two(options = {})
    fill_in_defendant('two', options)
  end

  def fill_in_defendant(defendant_number, options)
    defendant = "defendant_#{defendant_number}"
    fill_in_text_field(defendant, 'title')
    fill_in_text_field(defendant, 'full_name')
    choose_radio defendant, 'inhabits_property'
    if options[:complete_address] == true
      fill_in_text_field(defendant, 'street')
      fill_in_text_field(defendant, 'postcode')
    end
  end



  def fill_tenancy
    prefix = 'tenancy'
    choose_radio  prefix, 'tenancy_type'

    case get_data(prefix, 'tenancy_type')
    when 'Assured'
      choose_radio  prefix, 'assured_shorthold_tenancy_type'

      case get_data(prefix, 'assured_shorthold_tenancy_type')
      when 'one'
        fill_single_tenancy
      when 'multiple'
        fill_multiple_tenancy
      else
        raise 'Unexpected number of tenancy agreements'
      end
    when 'Demoted'
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

  def fill_notice_with_js
    if get_data('notice', 'served_by_name').nil?
      fill_notice
    else
      choose 'claim_notice_notice_served_yes'
      fill_notice
    end
  end

  def fill_notice
    prefix = 'notice'
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

end
