def claim_post_data
  { "claim" =>
    { "landlord" =>
      {
        "company" => "Landlordly LTD",
        "street" => "Secret Lair 2",
        "town" => "Evil",
        "postcode" => "SW1W 0LU"
      },
      "property" =>
      { "street" => "Mucho Gracias Road",
        "town" => "London",
        "postcode" => "SW1H 9AJ",
        "house"=>"A house"
      },
      "demoted_tenancy" =>
      {
        "assured" => true,
        "demotion_order_date" => "14 10 2014",
        "county_court" => "Cool County Court"
      },
      "notice" =>
      {
        "served_by" => "Somebody",
        "date_served" => "02 02 2014",
        "expiry_date" => "02 02 2014"
      },
      "license" =>
      {
        "hmo" => true,
        "authority" => "Great authority",
        "hmo_date" => "02 02 2014",
        "housing_act" => true,
        "housing_act_authority" => "Grand authority",
        "housing_act_date" => "02 02 2014"
      },
      "deposit" =>
      {
        "received" => true,
        "ref_number" => "X1234",
        "as_property" => true
      },
      "defendant" =>
      {
        "hearing" => true
      },
      "order" =>
      {
        "possession" => true,
        "cost" => true
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
      }
    }
  }
end


def claim_formatted_data
  {
    "landlord_address" => "Landlordly LTD\nSecret Lair 2\nEvil",
    "landlord_postcode1" => "SW1W",
    "landlord_postcode2" => "0LU",
    "property_address" => "Mucho Gracias Road\nLondon",
    "property_postcode1" => "SW1H",
    "property_postcode2" => "9AJ",
    "tenant_one_address" => "Mr John Major\nSesame Street\nLondon",
    "tenant_one_postcode1" => "SW1X",
    "tenant_one_postcode2" => "2PT",
    "tenant_two_address" => "Ms Jane Major\nSesame Street\nLondon",
    "tenant_two_postcode1" => "SW1X",
    "tenant_two_postcode2" => "2PT",
    "defendant_hearing" => true,
    "notice_date_served_day" => "02",
    "notice_date_served_month" => "02",
    "notice_date_served_year" => "2014",
    "notice_expiry_date_day" => "02",
    "notice_expiry_date_month" => "02",
    "notice_expiry_date_year" => "2014",
    "notice_served_by" => "Somebody",
    "order_cost" => true,
    "order_possession" => true,
    "license_authority" => "Great authority",
    "license_hmo" => true,
    "license_hmo_day" => "02",
    "license_hmo_month" => "02",
    "license_hmo_year" => "2014",
    "license_housing_act" => true,
    "license_housing_act_authority" => "Grand authority",
    "license_housing_act_date_day" => "02",
    "license_housing_act_date_month" => "02",
    "license_housing_act_date_year" => "2014",
    "deposit_as_property" => true,
    "deposit_received" => true,
    "deposit_ref_number" => "X1234",
  }
end
