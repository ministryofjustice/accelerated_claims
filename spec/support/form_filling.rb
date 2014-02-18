
def get_month val
  Date::MONTHNAMES[val.to_i]
end

def fill_property_details
  data = claim_post_data["claim"]["property"]
  fill_in 'claim_property_street', with: data["street"]
  fill_in 'claim_property_town', with: data["town"]
  fill_in 'claim_property_postcode', with: data["postcode"]
  choose 'claim_property_house_yes'
end

def fill_claimant_one
  data = claim_post_data["claim"]["claimant_one"]
  fill_in 'claim_claimant_one_company', with: data["company"]
  fill_in 'claim_claimant_one_street', with: data["street"]
  fill_in 'claim_claimant_one_town', with: data["town"]
  fill_in 'claim_claimant_one_postcode', with: data["postcode"]
end

def fill_claimant_two
  data = claim_post_data["claim"]["claimant_two"]
  fill_in 'claim_claimant_two_company', with: data["company"]
  fill_in 'claim_claimant_two_street', with: data["street"]
  fill_in 'claim_claimant_two_town', with: data["town"]
  fill_in 'claim_claimant_two_postcode', with: data["postcode"]
end

def fill_defendant_one
  data = claim_post_data["claim"]["defendant_one"]
  fill_in 'claim_defendant_one_title', with: data["title"]
  fill_in 'claim_defendant_one_full_name', with: data["full_name"]
  fill_in 'claim_defendant_one_street', with: data["street"]
  fill_in 'claim_defendant_one_postcode', with: data["postcode"]
end

def fill_defendant_two
  data = claim_post_data["claim"]["defendant_two"]
  fill_in 'claim_defendant_two_title', with: data["title"]
  fill_in 'claim_defendant_two_full_name', with: data["full_name"]
  fill_in 'claim_defendant_two_street', with: data["street"]
  fill_in 'claim_defendant_two_postcode', with: data["postcode"]
end

def fill_tenancy
  data = claim_post_data["claim"]["tenancy"]
  select(data["start_date(3i)"], :from => 'claim_tenancy_start_date_3i')
  select(get_month(data["start_date(2i)"]), :from => 'claim_tenancy_start_date_2i')
  select(data["start_date(1i)"], :from => 'claim_tenancy_start_date_1i')

  select(data["latest_agreement_date(3i)"], :from => 'claim_tenancy_latest_agreement_date_3i')
  select(get_month(data["latest_agreement_date(2i)"]), :from => 'claim_tenancy_latest_agreement_date_2i')
  select(data["latest_agreement_date(1i)"], :from => 'claim_tenancy_latest_agreement_date_1i')

  choose 'claim_tenancy_agreement_reissued_for_same_property_yes'
  choose 'claim_tenancy_agreement_reissued_for_same_landlord_and_tenant_yes'
end

def fill_notice
  data = claim_post_data["claim"]["notice"]
  fill_in 'claim_notice_served_by', with: data["served_by"]

  select(data["date_served(3i)"], :from => 'claim_notice_date_served_3i')
  select(get_month(data["date_served(2i)"]), :from => 'claim_notice_date_served_2i')
  select(data["date_served(1i)"], :from => 'claim_notice_date_served_1i')

  select(data["expiry_date(3i)"], :from => 'claim_notice_expiry_date_3i')
  select(get_month(data["expiry_date(2i)"]), :from => 'claim_notice_expiry_date_2i')
  select(data["expiry_date(1i)"], :from => 'claim_notice_expiry_date_1i')
end

def fill_licences
  data = claim_post_data["claim"]["license"]
  choose 'claim_license_hmo_yes'
  fill_in 'claim_license_authority', with: data["authority"]

  select(data["hmo_date(3i)"], :from => 'claim_license_hmo_date_3i')
  select(get_month(data["hmo_date(2i)"]), :from => 'claim_license_hmo_date_2i')
  select(data["hmo_date(1i)"], :from => 'claim_license_hmo_date_1i')

  choose 'claim_license_housing_act_yes'

  fill_in 'claim_license_housing_act_authority', with: data["housing_act_authority"]

  select(data["housing_act_date(3i)"], :from => 'claim_license_housing_act_date_3i')
  select(get_month(data["housing_act_date(2i)"]), :from => 'claim_license_housing_act_date_2i')
  select(data["housing_act_date(1i)"], :from => 'claim_license_housing_act_date_1i')
end

def fill_deposit
  choose 'claim_deposit_received_yes'
  fill_in 'claim_deposit_ref_number', with: claim_post_data["claim"]["deposit"]["ref_number"]
  choose 'claim_deposit_as_property_yes'
end

def fill_postponement
  choose 'claim_possession_hearing_yes'
end

def fill_order
  check 'claim_order_possession'
  check 'claim_order_cost'
end
