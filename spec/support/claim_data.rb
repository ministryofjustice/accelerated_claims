# -*- coding: utf-8 -*-
def claim_post_data
  HashWithIndifferentAccess.new(
  { "claim" =>
    { "livepc" => false,
      "num_claimants" => 2,
      "claimant_type" => 'individual',
      "claimant_1" =>
      {
        "title" => "Mr",
        "full_name" => "John Smith",
        "street" => "2 Brown St\nCwmbran",
        "postcode" => "sw1w0lu",
        claimant_num: 1
      },
      "claimant_contact" =>
      {
        "title" => "Mr",
        "full_name" => "Jim Brown",
        "company_name" => "Winning",
        "street" => "3 Smith St\nWinsum",
        "postcode" => "sw1w0lu",
        "email" => "jim@example.com",
        "phone" => "020 000 000",
        "fax" => "020 000 000",
        "dx_number" => "DX 123",
      },
      "reference_number" =>
      {
        "reference_number" => "my-ref-123"
      },
      'legal_cost' =>
      {
        "legal_costs" => '123.34'
      },
      "claimant_2" =>
      {
        "title" => "Ms",
        "full_name" => "Jane Smith",
        "street" => "7 Main St\nAlfreton",
        "postcode" => "SW1W 0LU",
        claimant_num: 2,
        address_same_as_first_claimant: 'No'
      },
      "property" =>
      { "street" => "Mucho Gracias Road\nLondon",
        "postcode" => "SW1H 9AJ",
        "house"=>"Yes"
      },
      "notice" =>
      {
        "notice_served" => "Yes",
        "served_by_name" => "Somebody",
        "served_method" => "In person",
        "date_served(3i)" => "2",
        "date_served(2i)" => "2",
        "date_served(1i)" => "2014",
        "expiry_date(3i)" => "3",
        "expiry_date(2i)" => "4",
        "expiry_date(1i)" => "2014",
      },
      "license" =>
      {
        'multiple_occupation' => 'Yes',
        'issued_under_act_part_yes' => 'Part2',
        'issued_by' => 'Great authority'
      }.merge(
        form_date('issued_date', Date.parse('2014-02-02'))
      ),
      "deposit" =>
      {
        "received" => 'Yes',
        "ref_number" => "X1234",
        "information_given_date(3i)" => "1",
        "information_given_date(2i)" => "2",
        "information_given_date(1i)" => "2010",
        "as_property" => 'Yes',
        "as_money" => 'Yes'
      },
      "possession" =>
      {
        "hearing" => 'Yes'
      },
      "order" =>
      {
        "cost" => 'No'
      },
      "num_defendants" => '2',
      "defendant_1"=>
      {
        "title" => "Mr",
        "full_name" => "John Major",
        "inhabits_property" => "No",
        "street" => "Sesame Street\nLondon",
        "postcode" => "sw1x2pt"
      },
      "defendant_2"=>
      {
        "title" => "Ms",
        "full_name" => "Jane Major",
        "inhabits_property" => "No",
        "street" => "Sesame Street\nLondon",
        "postcode" => "SW1X 2PT"
      },
      "tenancy" =>
      {
        'tenancy_type' => 'assured',
        'assured_shorthold_tenancy_type' => 'multiple',
        "demotion_order_date(3i)" => nil,
        "demotion_order_date(2i)" => nil,
        "demotion_order_date(1i)" => nil,
        'demotion_order_court' => nil,
        "previous_tenancy_type" => nil,
        "start_date(3i)" => nil,
        "start_date(2i)" => nil,
        "start_date(1i)" => nil,
        "original_assured_shorthold_tenancy_agreement_date(3i)" => "1",
        "original_assured_shorthold_tenancy_agreement_date(2i)" => "1",
        "original_assured_shorthold_tenancy_agreement_date(1i)" => "2010",
        "latest_agreement_date(3i)" => "1",
        "latest_agreement_date(2i)" => "1",
        "latest_agreement_date(1i)" => "2010",
        "agreement_reissued_for_same_property" => 'No',
        "agreement_reissued_for_same_landlord_and_tenant" => 'No',
        "assured_shorthold_tenancy_notice_served_by" => 'Mr Brown',
        "assured_shorthold_tenancy_notice_served_date(3i)" => "1",
        "assured_shorthold_tenancy_notice_served_date(2i)" => "12",
        "assured_shorthold_tenancy_notice_served_date(1i)" => "2013",
        "confirmed_second_rules_period_applicable_statements" => 'Yes',
        "confirmed_first_rules_period_applicable_statements" => 'No'
      },
      "fee" =>
      {
        "court_fee" => "280"
      }
    }
  }
  )
end

def demoted_claim_post_data
  data = claim_post_data
  data['claim']['tenancy'] = {
    'tenancy_type' => 'demoted',
    'demotion_order_date(3i)' => '1',
    'demotion_order_date(2i)' => '1',
    'demotion_order_date(1i)' => '2010',
    'demotion_order_court' => 'Brighton County Court',
    'previous_tenancy_type' => 'assured'
  }
  data
end

def claim_with_3_claimants_formatted_data
  data = claim_formatted_data
  data['claimant_3_address'] = "Miss Ann Chovey\n2 High Street\nAnytown"
  data['claimant_3_postcode1'] = 'AY3'
  data['claimant_3_postcode2'] = '0XX'
  data
end

def claim_with_4_claimants_formatted_data
  data = claim_with_3_claimants_formatted_data
  data['claimant_4_address'] = "Mr Mark Atteer\n2 High Street\nAnytown"
  data['claimant_4_postcode1'] = 'AY34'
  data['claimant_4_postcode2'] = '9ZZ'
  data
end

def claim_formatted_data
  {
    "fee_court_fee" => "280",
    "claimant_1_address" => "Mr John Smith\n2 Brown St\nCwmbran",
    "claimant_1_postcode1" => "SW1W",
    "claimant_1_postcode2" => "0LU",
    "claimant_contact_address" => "Mr Jim Brown\nWinning\n3 Smith St\nWinsum",
    "claimant_contact_postcode1" => "SW1W",
    "claimant_contact_postcode2" => "0LU",
    "claimant_contact_email" => "jim@example.com",
    "claimant_contact_phone" => "020 000 000",
    "claimant_contact_fax" => "020 000 000",
    "claimant_contact_dx_number" => "DX 123",
    "claimant_contact_reference_number" => "my-ref-123",
    "claimant_contact_legal_costs" => "123.34",
    "claimant_2_address" => "Ms Jane Smith\n7 Main St\nAlfreton",
    "claimant_2_postcode1" => "SW1W",
    "claimant_2_postcode2" => "0LU",
    "property_address" => "Mucho Gracias Road\nLondon",
    "property_postcode1" => "SW1H",
    "property_postcode2" => "9AJ",
    "property_house" => "Yes",
    "defendant_1_address" => "Mr John Major\nSesame Street\nLondon",
    "defendant_1_postcode1" => "SW1X",
    "defendant_1_postcode2" => "2PT",
    "defendant_2_address" => "Ms Jane Major\nSesame Street\nLondon",
    "defendant_2_postcode1" => "SW1X",
    "defendant_2_postcode2" => "2PT",
    "possession_hearing" => 'Yes',
    "notice_date_served_day" => "02",
    "notice_date_served_month" => "02",
    "notice_date_served_year" => "2014",
    "notice_expiry_date_day" => "03",
    "notice_expiry_date_month" => "04",
    "notice_expiry_date_year" => "2014",
    "notice_served_by" => "Somebody, In person",
    "order_cost" => 'No',
    "order_possession" => 'Yes',
    "license_multiple_occupation" => 'Yes',
    "license_part2_authority" => "Great authority",
    "license_part2_day" => "02",
    "license_part2_month" => "02",
    "license_part2_year" => "2014",
    "license_part3" => 'No',
    "license_part3_authority" => "",
    "license_part3_day" => "",
    "license_part3_month" => "",
    "license_part3_year" => "",
    "deposit_as_property" => 'Yes',
    "deposit_received" => 'Yes',
    "deposit_ref_number" => "X1234",
    'deposit_information_given_date_day' => '01',
    'deposit_information_given_date_month' => '02',
    'deposit_information_given_date_year' => '2010',
    'tenancy_demoted_tenancy' => 'No',
    "tenancy_demotion_order_date_day" => nil,
    "tenancy_demotion_order_date_month" => nil,
    "tenancy_demotion_order_date_year" => nil,
    'tenancy_demotion_order_court' => nil,
    'tenancy_previous_tenancy_type' => nil,
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
    'tenancy_applicable_statements_1' => 'Yes',
    'tenancy_applicable_statements_2' => 'Yes',
    'tenancy_applicable_statements_3' => 'Yes',
    'tenancy_applicable_statements_4' => 'No',
    'tenancy_applicable_statements_5' => 'No',
    'tenancy_applicable_statements_6' => 'No',
    "total_cost" => "403.34"
  }
end

def demoted_claim_formatted_data
  data = claim_formatted_data
  data.merge!(
    'tenancy_demoted_tenancy' => 'Yes',
    'tenancy_demotion_order_date_day' => '01',
    'tenancy_demotion_order_date_month' => '01',
    'tenancy_demotion_order_date_year' => '2010',
    'tenancy_demotion_order_court' => 'Brighton',
    'tenancy_previous_tenancy_type' => 'assured',

    "tenancy_agreement_reissued_for_same_landlord_and_tenant" => nil,
    "tenancy_agreement_reissued_for_same_property" => nil,
    "tenancy_latest_agreement_date_day" => nil,
    "tenancy_latest_agreement_date_month" => nil,
    "tenancy_latest_agreement_date_year" => nil,
    "tenancy_start_date_day" => nil,
    "tenancy_start_date_month" => nil,
    "tenancy_start_date_year" => nil,
    "tenancy_assured_shorthold_tenancy_notice_served_by" => nil,
    "tenancy_assured_shorthold_tenancy_notice_served_date_day" => nil,
    "tenancy_assured_shorthold_tenancy_notice_served_date_month" => nil,
    "tenancy_assured_shorthold_tenancy_notice_served_date_year" => nil,
    'tenancy_applicable_statements_1' => nil,
    'tenancy_applicable_statements_2' => nil,
    'tenancy_applicable_statements_3' => nil,
    'tenancy_applicable_statements_4' => nil,
    'tenancy_applicable_statements_5' => nil,
    'tenancy_applicable_statements_6' => nil
    )
  data
end
