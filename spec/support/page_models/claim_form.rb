class ClaimForm
  include Capybara::DSL

  def initialize(data)
    @data = data
    visit '/new'
  end

  def complete_form
    fill_property_details
    fill_claimant_one
    fill_claimant_two
    fill_defendant_one
    fill_defendant_two
    fill_claimant_solicitor_address
    fill_claimant_contact_details
    fill_solicitor
    fill_demoted_tenancy
    fill_tenancy
    fill_notice
    fill_licences
    fill_deposit
    fill_postponement
    check_order_possession_and_cost
    fill_court_fee
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
    fill_in("claim_#{prefix}_#{key}", with: get_data(prefix, key) )
  end

  def get_data prefix, key
    begin
      @data['claim'][prefix][key]
    rescue Exception => e
      binding.pry
      raise ['no data', prefix, key].join(': ')
    end
  end

  def choose_radio(prefix, key)
    choice = get_data(prefix,key)
    choose("claim_#{prefix}_#{key}_#{choice}".downcase) unless choice.nil?
  end

  def check_box(prefix, key)
    check("claim_#{prefix}_#{key}") if(get_data(prefix, key).downcase == 'yes')
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

  def complete_details_of_person(prefix)
    fill_in_text_field(prefix, 'title')
    fill_in_text_field(prefix, 'full_name')
    fill_in_text_field(prefix, 'street')
    fill_in_text_field(prefix, 'town')
    fill_in_text_field(prefix, 'postcode')
  end

  def fill_property_details
    prefix = 'property'
    fill_in_text_field(prefix, 'street')
    fill_in_text_field(prefix, 'town')
    fill_in_text_field(prefix, 'postcode')

    adjust_data 'property', 'house', yes_value='house'
    choose_radio(prefix, 'house')
  end

  def adjust_data prefix, key, yes_value
    @data['claim'][prefix][key] = (get_data(prefix,key) == yes_value) ? 'Yes' : 'No'
  end

  def fill_claimant_one
    complete_details_of_person('claimant_one')
  end

  def fill_claimant_two
    complete_details_of_person('claimant_two')
  end

  def fill_defendant_one
    complete_details_of_person('defendant_one')
  end

  def fill_defendant_two
    complete_details_of_person('defendant_two')
  end

  def fill_demoted_tenancy
    prefix = 'demoted_tenancy'
    choose_radio(prefix, 'demoted_tenancy')

    select_date(prefix, 'demotion_order_date')
    fill_in_text_field(prefix, 'demotion_order_court')
  end


  def fill_tenancy
    prefix = 'tenancy'
    select_date prefix, 'start_date'
    select_date prefix, 'latest_agreement_date'
    choose_radio prefix,'reissued_for_same_property'
    choose_radio prefix, 'reissued_for_same_landlord_and_tenant'
    select_date prefix, 'assured_shorthold_tenancy_notice_served_date'
    fill_in_text_field prefix, 'assured_shorthold_tenancy_notice_served_by'
  end

  def fill_notice
    prefix = 'notice'
    fill_in_text_field(prefix, 'served_by')
    select_date(prefix, 'date_served')
    select_date(prefix, 'expiry_date')
  end

  def fill_licences
    prefix = 'license'

    choose_radio(prefix, 'multiple_occupation')

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
  end

  def fill_deposit
    prefix = 'deposit'
    choose_radio(prefix,'received')
    fill_in_text_field(prefix, 'ref_number')
    choose_radio(prefix, 'as_property')
  end

  def fill_possession
    prefix = 'possession'
    choose_radio(prefix, 'hearing')
  end

  def check_order_possession_and_cost
    prefix = 'order'
    check_box(prefix, 'possession')
    check_box(prefix, 'cost')
  end

  def fill_solicitor
    prefix = 'claimant_contact'
    fill_in_text_field(prefix, 'legal_costs')
    complete_details_of_person(prefix)
    fill_in_text_field(prefix, 'email')
    fill_in_text_field(prefix, 'phone')
    fill_in_text_field(prefix, 'fax')
    fill_in_text_field(prefix, 'dx_number')
    fill_in_text_field(prefix, 'reference_number')
  end

  def fill_court_fee
    prefix = 'fee'
    fill_in_text_field(prefix, 'court_fee')
  end

end