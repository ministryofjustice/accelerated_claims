# -*- coding: utf-8 -*-
def claim_post_data
  { "claim" =>
    { "claimant_one" =>
      {
        "title" => "Mr",
        "full_name" => "John Smith",
        "street" => "2 Brown St",
        "town" => "Cwmbran",
        "postcode" => "SW1W 0LU"
      },
      "claimant_contact" =>
      {
        "title" => "Mr",
        "full_name" => "Jim Brown",
        "street" => "3 Smith St",
        "town" => "Winsum",
        "postcode" => "SW1W 0LU",
        "email" => "jim@example.com",
        "phone" => "020 000 000",
        "fax" => "020 000 000",
        "dx_number" => "DX 123",
        "reference_number" => "my-ref-123",
        "legal_costs" => '123.34'
      },
      "claimant_two" =>
      {
        "title" => "Ms",
        "full_name" => "Jane Smith",
        "street" => "7 Main St",
        "town" => "Alfreton",
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
        "date_served(3i)" => "2",
        "date_served(2i)" => "2",
        "date_served(1i)" => "2014",
        "expiry_date(3i)" => "2",
        "expiry_date(2i)" => "2",
        "expiry_date(1i)" => "2014",
      },
      "license" =>
      {
        'multiple_occupation' => 'Yes',
        'license_issued_under' => 'Part2',
        'license_issued_by' => 'Great authority'
      }.merge(
        form_date('license_issued_date', Date.parse('2014-02-02'))
      ),
      "deposit" =>
      {
        "received" => 'Yes',
        "ref_number" => "X1234",
        "as_property" => 'Yes'
      },
      "possession" =>
      {
        "hearing" => 'Yes'
      },
      "order" =>
      {
        "possession" => 'Yes',
        "cost" => 'No'
      },
      "defendant_one"=>
      {
        "title" => "Mr",
        "full_name" => "John Major",
        "street" => "Sesame Street",
        "town" => "London",
        "postcode" => "SW1X 2PT"
      },
      "defendant_two"=>
      {
        "title" => "Ms",
        "full_name" => "Jane Major",
        "street" => "Sesame Street",
        "town" => "London",
        "postcode" => "SW1X 2PT"
      },
      "demoted_tenancy" =>
      {
        'demoted_tenancy' => 'Yes',
        "demotion_order_date(3i)" => "1",
        "demotion_order_date(2i)" => "1",
        "demotion_order_date(1i)" => "2010",
        'demotion_order_court' => 'Brighton County Court'
      },
      "tenancy" =>
      {
        "start_date(3i)" => "1",
        "start_date(2i)" => "1",
        "start_date(1i)" => "2010",
        "latest_agreement_date(3i)" => "1",
        "latest_agreement_date(2i)" => "1",
        "latest_agreement_date(1i)" => "2010",
        "reissued_for_same_property" => 'No',
        "reissued_for_same_landlord_and_tenant" => 'No',
        "assured_shorthold_tenancy_notice_served_by" => 'Mr Brown',
        "assured_shorthold_tenancy_notice_served_date(3i)" => "1",
        "assured_shorthold_tenancy_notice_served_date(2i)" => "12",
        "assured_shorthold_tenancy_notice_served_date(1i)" => "2013"
      },
      "fee" =>
      {
        "court_fee" => "175.00"
      },
    }
  }
end


def claim_formatted_data
  {
    "fee_court_fee" => "175.00",
    "claimant_one_address" => "Mr John Smith\n2 Brown St\nCwmbran",
    "claimant_one_postcode1" => "SW1W",
    "claimant_one_postcode2" => "0LU",
    "claimant_contact_address" => "Mr Jim Brown\n3 Smith St\nWinsum",
    "claimant_contact_postcode1" => "SW1W",
    "claimant_contact_postcode2" => "0LU",
    "claimant_contact_email" => "jim@example.com",
    "claimant_contact_phone" => "020 000 000",
    "claimant_contact_fax" => "020 000 000",
    "claimant_contact_dx_number" => "DX 123",
    "claimant_contact_reference_number" => "my-ref-123",
    "claimant_contact_legal_costs" => "123.34",
    "claimant_two_address" => "Ms Jane Smith\n7 Main St\nAlfreton",
    "claimant_two_postcode1" => "SW1W",
    "claimant_two_postcode2" => "0LU",
    "property_address" => "Mucho Gracias Road\nLondon",
    "property_postcode1" => "SW1H",
    "property_postcode2" => "9AJ",
    "property_house" => "Yes",
    "defendant_one_address" => "Mr John Major\nSesame Street\nLondon",
    "defendant_one_postcode1" => "SW1X",
    "defendant_one_postcode2" => "2PT",
    "defendant_two_address" => "Ms Jane Major\nSesame Street\nLondon",
    "defendant_two_postcode1" => "SW1X",
    "defendant_two_postcode2" => "2PT",
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
    "license_housing_act_authority" => "",
    "license_housing_act_date_day" => "",
    "license_housing_act_date_month" => "",
    "license_housing_act_date_year" => "",
    "deposit_as_property" => 'Yes',
    "deposit_received" => 'Yes',
    "deposit_ref_number" => "X1234",
    'demoted_tenancy_demoted_tenancy' => 'Yes',
    "demoted_tenancy_demotion_order_date_day" => "01",
    "demoted_tenancy_demotion_order_date_month" => "01",
    "demoted_tenancy_demotion_order_date_year" => "2010",
    'demoted_tenancy_demotion_order_court' => 'Brighton',
    "tenancy_agreement_reissued_for_same_landlord_and_tenant" => "No",
    "tenancy_agreement_reissued_for_same_property" => "No",
    "tenancy_latest_agreement_date_day" => "01",
    "tenancy_latest_agreement_date_month" => "01",
    "tenancy_latest_agreement_date_year" => "2010",
    "tenancy_start_date_day" => "01",
    "tenancy_start_date_month" => "01",
    "tenancy_start_date_year" => "2010",
    "tenancy_assured_shorthold_tenancy_notice_served_by" => 'Mr Brown',
    "tenancy_assured_shorthold_tenancy_notice_served_date_day" => "01",
    "tenancy_assured_shorthold_tenancy_notice_served_date_month" => "12",
    "tenancy_assured_shorthold_tenancy_notice_served_date_year" => "2013",
    "total_cost" => "298.34"
  }
end
