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


  def fill_in_text_field(prefix, key)
    fill_in("claim_#{prefix}_#{key}", with: get_data(prefix, key) )
  end

  def get_data prefix, key
    @data['claim'][prefix][key]
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
    fill_in_text_field('property', 'street')
    fill_in_text_field('property', 'town')
    fill_in_text_field('property', 'postcode')
    choose 'claim_property_house_yes' # todo: decide based on fixture data
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
    choose 'claim_demoted_tenancy_demoted_tenancy_no' # todo: choose from fixture data

    select_date(prefix, 'demotion_order_date')
    fill_in_text_field(prefix, 'demotion_order_court')
  end


  def fill_tenancy
    prefix = 'tenancy'
    select_date prefix, 'start_date'
    select_date prefix, 'latest_agreement_date'
    choose 'claim_tenancy_reissued_for_same_property_yes' # todo
    choose 'claim_tenancy_reissued_for_same_landlord_and_tenant_yes' # todo
    select_date prefix, 'assured_shorthold_tenancy_notice_served_date'
    fill_in_text_field(prefix, 'assured_shorthold_tenancy_notice_served_by')
  end

  def fill_tenancy_reissued_no(data)
    choose 'claim_tenancy_reissued_for_same_property_no' # todo
    choose 'claim_tenancy_reissued_for_same_landlord_and_tenant_no' # todo
  end

  def fill_notice
    prefix = 'notice'
    fill_in_text_field(prefix, 'served_by')
    select_date(prefix, 'date_served')
    select_date(prefix, 'expiry_date')
  end

  def fill_licences
    prefix = 'license'
    choose 'claim_license_multiple_occupation_yes' # todo
    choose 'claim_license_issued_under_act_part_part2' # todo

    fill_in_text_field(prefix, 'issued_by')
    select_date(prefix, 'issued_date')
  end

  def fill_no_licence
    choose 'claim_license_multiple_occupation_no' # todo
  end

  def fill_no_deposit
    choose 'claim_deposit_received_no' # todo
    choose 'claim_deposit_as_property_no' # todo
  end

  def fill_deposit
    prefix = 'deposit'
    choose 'claim_deposit_received_yes' # todo
    fill_in_text_field(prefix, 'ref_number')
    choose 'claim_deposit_as_property_yes' # todo
  end

  def fill_postponement
    choose 'claim_possession_hearing_yes' # todo
  end

  def fill_no_postponement
    choose 'claim_possession_hearing_no' # todo
  end

  def check_order_possession_and_cost
    check 'claim_order_possession' # todo
    check 'claim_order_cost' # todo
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