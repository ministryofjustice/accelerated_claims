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
      "tenant_one"=>{}, 
      "tenant_two"=>{}
    }
  }
end
