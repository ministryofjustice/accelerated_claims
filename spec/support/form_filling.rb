
def fill_property_details
  fill_in 'claim_property_street', with: 'Streety Street'
  fill_in 'claim_property_town', with: 'London'
  fill_in 'claim_property_postcode', with: 'SW1H 9end'
  choose 'claim_property_house_yes'
end

def fill_claimant_one
  fill_in 'claim_claimant_one_company', with: 'Mr Landlord Landlordson'
  fill_in 'claim_claimant_one_street', with: '7 Landlord Road'
  fill_in 'claim_claimant_one_town', with: 'London'
  fill_in 'claim_claimant_one_postcode', with: 'SW1W 7FF'
end

def fill_claimant_two
  fill_in 'claim_claimant_two_company', with: 'Ms Landlady Landlordson'
  fill_in 'claim_claimant_two_street', with: '7 Landlord Road'
  fill_in 'claim_claimant_two_town', with: 'London'
  fill_in 'claim_claimant_two_postcode', with: 'SW1W 7FF'
end

def fill_defendant_one
  fill_in 'claim_defendant_one_title', with: 'Mr'
  fill_in 'claim_defendant_one_full_name', with: 'Tenanty Tenant'
  fill_in 'claim_defendant_one_street', with: 'Streety Street'
  fill_in 'claim_defendant_one_postcode', with: 'London'
end

def fill_defendant_two
  fill_in 'claim_defendant_two_title', with: 'Ms'
  fill_in 'claim_defendant_two_full_name', with: 'Tenanty Tenant'
  fill_in 'claim_defendant_two_street', with: 'Streety Street'
  fill_in 'claim_defendant_two_postcode', with: 'London'
end

def fill_tenancy
  select('1', :from => 'claim_tenancy_start_date_3i')
  select('May', :from => 'claim_tenancy_start_date_2i')
  select('2011', :from => 'claim_tenancy_start_date_1i')

  select('1', :from => 'claim_tenancy_latest_agreement_date_3i')
  select('May', :from => 'claim_tenancy_latest_agreement_date_2i')
  select('2011', :from => 'claim_tenancy_latest_agreement_date_1i')

  choose 'claim_tenancy_agreement_reissued_for_same_property_yes'
  choose 'claim_tenancy_agreement_reissued_for_same_landlord_and_tenant_yes'
end

def fill_notice
  fill_in 'claim_notice_served_by', with: 'Notice Server'

  select('1', :from => 'claim_notice_date_served_3i')
  select('May', :from => 'claim_notice_date_served_2i')
  select('2012', :from => 'claim_notice_date_served_1i')

  select('1', :from => 'claim_notice_expiry_date_3i')
  select('June', :from => 'claim_notice_expiry_date_2i')
  select('2012', :from => 'claim_notice_expiry_date_1i')
end

def fill_licences
  choose 'claim_license_hmo_yes'
  fill_in 'claim_license_authority', with: 'Westminster Council'

  select('1', :from => 'claim_license_hmo_date_3i')
  select('February', :from => 'claim_license_hmo_date_2i')
  select('2008', :from => 'claim_license_hmo_date_1i')

  choose 'claim_license_housing_act_yes'

  fill_in 'claim_license_housing_act_authority', with: 'Westminster Council'

  select('1', :from => 'claim_license_housing_act_date_3i')
  select('February', :from => 'claim_license_housing_act_date_2i')
  select('2008', :from => 'claim_license_housing_act_date_1i')
end

def fill_deposit
  choose 'claim_deposit_received_yes'
  fill_in 'claim_deposit_ref_number', with: 'XYZ123'
  choose 'claim_deposit_as_property_yes'
end

def fill_postponement
  choose 'claim_possession_hearing_yes'
end

def fill_order
  check 'claim_order_possession'
  check 'claim_order_cost'
end
