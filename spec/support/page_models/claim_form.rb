class ClaimForm
  include Capybara::DSL

  def initialize(data)
    @data = data
  end

  def complete_form
    @js_on = false
    fill_property_details
    fill_claimant_one
    fill_claimant_two
    fill_defendant_one
    fill_defendant_two
    fill_claimant_contact
    fill_tenancy
    fill_notice
    fill_licences
    fill_deposit
    fill_postponement
    check_order_possession_and_cost
    fill_court_fee
    fill_legal_costs
    fill_reference_number
  end

  def complete_form_with_javascript
    @js_on = true
    fill_property_details
    number_of_claimants = select_number_of :claimants

    fill_claimant_one
    if number_of_claimants == 2
      choose_claimant_two_address_the_same
      fill_claimant_two
    end

    number_of_defendants = select_number_of :defendants

    choose_defendant_living_in_property 'one',1
    fill_defendant_one
    if number_of_defendants == 2
      choose_defendant_living_in_property 'two',2
      fill_defendant_two
    end

    fill_claimant_contact_with_js

    fill_tenancy
    fill_notice
    fill_licences
    fill_deposit
    fill_postponement
    check_order_possession_and_cost
    fill_court_fee
    fill_legal_costs
    fill_reference_number
  end

  def select_number_of type
    number = get_data('javascript', "number_of_#{type}").to_i

    case number
      when 1
        choose("multiplePanelRadio_#{type}_1")
      when 2
        choose("multiplePanelRadio_#{type}_2")
    end

    find("#claim_#{type.to_s.singularize}_one_title") # wait for selector to be shown

    number
  end

  def choose_claimant_two_address_the_same
    case get_data('javascript','claimant_two_same_address')
    when 'Yes'
      choose('claimant2address-yes')
    else
      choose('claimant2address-no')
    end
  end

  def choose_defendant_living_in_property count, index
    case get_data('javascript', "choose_defendant_#{count}_living_in_property")
    when 'Yes'
      choose("defendant#{index}address-yes")
    else
      choose("defendant#{index}address-no")
    end
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
    fill_in_text_field('reference_number', 'reference_number')
  end

  def submit
    click_button 'Complete form'
  end

  def validation_error_text
    errors = ["Validation Errors:"]
    page.all('.error-summary li').each { |li| errors << "#{li.text}: #{li.find('a')['href']}" }
    errors.join("\n\t")
  end


  def fill_in_text_field(prefix, key)
    fill_in("claim_#{prefix}_#{key}", with: get_data(prefix, key))
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
      check("claim_#{prefix}_#{key}")
    end
  end

  def select_date prefix, key
    data = get_data(prefix, key)
    if data
      d = Date.parse(data)
      day = d.day
      month = Date::MONTHNAMES[d.month]
      year = d.year

      select(  day, :from => "claim_#{prefix}_#{key}_3i")
      select(month, :from => "claim_#{prefix}_#{key}_2i")
      select( year, :from => "claim_#{prefix}_#{key}_1i")
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



  def complete_details_of_person(prefix, options={})
    options = { complete_address: true }.merge(options)
    fill_in_text_field(prefix, 'title')
    fill_in_text_field(prefix, 'full_name')

    if options[:complete_address]
      fill_in_text_field(prefix, 'street')
      fill_in_text_field(prefix, 'postcode')

    elsif !@js_on && (prefix == 'claimant_two') && get_data('javascript', 'claimant_two_same_address').to_s[/Yes/]
      fill_in("claim_claimant_two_street", with: get_data('claimant_one', 'street'))
      fill_in("claim_claimant_two_postcode", with: get_data('claimant_one', 'postcode'))
    end
  end

  def fill_property_details
    prefix = 'property'
    fill_in_text_field(prefix, 'street')
    fill_in_text_field(prefix, 'postcode')

    choose_radio(prefix, 'house')
  end

  def fill_claimant_one
    complete_details_of_person('claimant_one')
  end

  def fill_claimant_two
    complete_address = (get_data('javascript', 'claimant_two_same_address') != 'Yes')

    complete_details_of_person('claimant_two', complete_address: complete_address)
  end

  def fill_defendant_one
    complete_details_of_person('defendant_one')
  end

  def fill_defendant_two
    complete_details_of_person('defendant_two')
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
      select_date   prefix, 'demotion_order_date'
      fill_in_text_field prefix, 'demotion_order_court'
      choose_radio  prefix, 'previous_tenancy_type'
    else
      raise 'Unexpected tenancy type'
    end
  end

  def fill_single_tenancy
    prefix = 'tenancy'
    select_date prefix, 'start_date'
    start_date = Date.parse(get_data(prefix, 'start_date'))

    if Tenancy.in_first_rules_period? start_date
      fill_in_text_field prefix, 'assured_shorthold_tenancy_notice_served_by'
      select_date   prefix, 'assured_shorthold_tenancy_notice_served_date'
    end
  end

  def fill_multiple_tenancy
    prefix = 'tenancy'
    choose_radio  prefix,'agreement_reissued_for_same_property'
    choose_radio  prefix, 'agreement_reissued_for_same_landlord_and_tenant'
    select_date   prefix, 'original_assured_shorthold_tenancy_agreement_date'
    select_date   prefix, 'latest_agreement_date'
    start_date = Date.parse(get_data(prefix, 'original_assured_shorthold_tenancy_agreement_date'))

    if Tenancy.in_first_rules_period? start_date
      fill_in_text_field prefix, 'assured_shorthold_tenancy_notice_served_by'
      select_date   prefix, 'assured_shorthold_tenancy_notice_served_date'
    end
  end

  def fill_notice
    prefix = 'notice'
    fill_in_text_field(prefix, 'served_by_name')
    fill_in_text_field(prefix, 'served_method')
    fill_in_moj_date_fieldset(prefix, 'date_served')
    fill_in_moj_date_fieldset(prefix, 'expiry_date')
    # select_date(prefix, 'date_served')
    # select_date(prefix, 'expiry_date')
  end

  def fill_licences
    prefix = 'license'
    choose_radio(prefix, 'multiple_occupation')

    case hmo = get_data(prefix, 'multiple_occupation')
      when /Yes/
        case part = get_data(prefix, 'issued_under_act_part')
          when /Part2/
            choose 'claim_license_issued_under_act_part_part2'
          when /Part3/
            choose 'claim_license_issued_under_act_part_part3'
          when nil
          else
            raise part
        end
        fill_in_text_field(prefix, 'issued_by')
        select_date(prefix, 'issued_date')
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
        fill_in_text_field(prefix, 'ref_number')
      end
    end
  end

  def fill_postponement
    choose_radio('possession','hearing')
  end

  def check_order_possession_and_cost
    prefix = 'order'
    check_box(prefix, 'possession')
    check_box(prefix, 'cost')
  end

  def fill_court_fee
    prefix = 'fee'
    # it is hardcoded value for now
    # fill_in_text_field(prefix, 'court_fee')
  end

end