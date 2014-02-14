def claim_post_data
  { "claim" =>
    { "landlord_one" =>
      {
        "company" => "Landlordly LTD",
        "street" => "Secret Lair 2",
        "town" => "Evil",
        "postcode" => "SW1W 0LU"
      },
      "landlord_two" =>
      {
        "company" => "Great Let LTD",
        "street" => "Devious Place 7",
        "town" => "Evil",
        "postcode" => "SW1W 0LU"
      },
      "property" =>
      { "street" => "Mucho Gracias Road",
        "town" => "London",
        "postcode" => "SW1H 9AJ",
        "house"=>"Yes"
      },
      "notice" =>
      {
        "served_by" => "Somebody",
        "date_served(3i)" => "02",
        "date_served(2i)" => "02",
        "date_served(1i)" => "2014",
        "expiry_date(3i)" => "02",
        "expiry_date(2i)" => "02",
        "expiry_date(1i)" => "2014",
      },
      "license" =>
      {
        "hmo" => true,
        "authority" => "Great authority",
        "hmo_date(3i)" => "02",
        "hmo_date(2i)" => "02",
        "hmo_date(1i)" => "2014",
        "housing_act" => false,
        "housing_act_authority" => "Grand authority",
        "housing_act_date(3i)" => "02",
        "housing_act_date(2i)" => "02",
        "housing_act_date(1i)" => "2014"
      },
      "deposit" =>
      {
        "received" => true,
        "ref_number" => "X1234",
        "as_property" => true
      },
      "possession" =>
      {
        "hearing" => true
      },
      "order" =>
      {
        "possession" => true,
        "cost" => false
      },
      "tenant_one"=>
      {
        "title" => "Mr",
        "full_name" => "John Major",
        "street" => "Sesame Street",
        "town" => "London",
        "postcode" => "SW1X 2PT"
      },
      "tenant_two"=>
      {
        "title" => "Ms",
        "full_name" => "Jane Major",
        "street" => "Sesame Street",
        "town" => "London",
        "postcode" => "SW1X 2PT"
      },
      "tenancy" =>
      {
        "start_date(3i)" => "2010",
        "start_date(2i)" => "01",
        "start_date(1i)" => "01",
        "latest_agreement_date(3i)" => "2010",
        "latest_agreement_date(2i)" => "01",
        "latest_agreement_date(1i)" => "01",
        "agreement_reissued_for_same_property" => false,
        "agreement_reissued_for_same_landlord_and_tenant" => false
      }
    }
  }
end


def claim_formatted_data
  {
    "landlord_one_address" => "Landlordly LTD\nSecret Lair 2\nEvil",
    "landlord_one_postcode1" => "SW1W",
    "landlord_one_postcode2" => "0LU",
    "landlord_two_address" => "Great Let LTD\nDevious Place 7\nEvil",
    "landlord_two_postcode1" => "SW1W",
    "landlord_two_postcode2" => "0LU",
    "property_address" => "Mucho Gracias Road\nLondon",
    "property_postcode1" => "SW1H",
    "property_postcode2" => "9AJ",
    "property_house" => "Yes",
    "tenant_one_address" => "Mr John Major\nSesame Street\nLondon",
    "tenant_one_postcode1" => "SW1X",
    "tenant_one_postcode2" => "2PT",
    "tenant_two_address" => "Ms Jane Major\nSesame Street\nLondon",
    "tenant_two_postcode1" => "SW1X",
    "tenant_two_postcode2" => "2PT",
    "possession_hearing" => 'Yes',
    "notice_date_served_day" => "02",
    "notice_date_served_month" => "02",
    "notice_date_served_year" => "2014",
    "notice_expiry_date_day" => "02",
    "notice_expiry_date_month" => "02",
    "notice_expiry_date_year" => "2014",
    "notice_served_by" => "Somebody",
    "order_cost" => 'No',
    "order_possession" => 'Yes',
    "license_authority" => "Great authority",
    "license_hmo" => 'Yes',
    "license_hmo_day" => "02",
    "license_hmo_month" => "02",
    "license_hmo_year" => "2014",
    "license_housing_act" => 'No',
    "license_housing_act_authority" => "Grand authority",
    "license_housing_act_date_day" => "02",
    "license_housing_act_date_month" => "02",
    "license_housing_act_date_year" => "2014",
    "deposit_as_property" => 'Yes',
    "deposit_received" => 'Yes',
    "deposit_ref_number" => "X1234",
    "tenancy_agreement_reissued_for_same_landlord_and_tenant" => "No",
    "tenancy_agreement_reissued_for_same_property" => "No",
    "tenancy_latest_agreement_date_day" => "01",
    "tenancy_latest_agreement_date_month" => "01",
    "tenancy_latest_agreement_date_year" => "2010",
    "tenancy_start_date_day" => "01",
    "tenancy_start_date_month" => "01",
    "tenancy_start_date_year" => "2010",
  }
end
