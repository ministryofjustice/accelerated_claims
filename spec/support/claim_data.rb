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
      "demoted_tenancy"=>{},
      "notice"=>{},
      "license"=>{},
      "deposit"=>{},
      "defendant"=>{},
      "order"=>{},
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
    "claimant" => "Landlordly LTD\nSecret Lair 2\nEvil",
    "claimant_postcode1" => "SW1W",
    "claimant_postcode2" => "0LU",
    "property" => "Mucho Gracias Road\nLondon",
    "property_postcode1" => "SW1H",
    "property_postcode2" => "9AJ",
    "defendant1" => "Mr John Major\nSesame Street\nLondon",
    "defendant1_postcode1" => "SW1X",
    "defendant1_postcode2" => "2PT",
    "defendant2" => "Ms Jane Major\nSesame Street\nLondon",
    "defendant2_postcode1" => "SW1X",
    "defendant2_postcode2" => "2PT"
  }
end
