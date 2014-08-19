require_relative '../spec_helper'
require_relative '../../app/lib/error_message_sequencer'

describe ErrorMessageSequencer do

  let(:claim_claimant_number_of_claimants_error) { ['claim_claimant_number_of_claimants_error', 'msg']}
  let(:claim_property_street_error)         { ['claim_property_street_error',                   'msg']}
  let(:claim_property_postcode_error)       { ['claim_property_postcode_error',                 'msg']}
  let(:claim_property_house_error)          { ['claim_property_house_error',                    'msg']}
  let(:claim_notice_served_by_name_error)   { ['claim_notice_served_by_name_error',             'msg']}
  let(:claim_notice_served_method_error)    { ['claim_notice_served_method_error',              'msg']}
  let(:claim_notice_date_served_error)      { ['claim_notice_date_served_error',                'msg']}
  let(:claim_notice_expiry_date_error)      { ['claim_notice_expiry_date_error',                'msg']}
  let(:claim_license_multiple_occupation_error) { ['claim_license_multiple_occupation_error',   'msg']}
  let(:claim_deposit_as_money_error)        { ['claim_deposit_as_money_error',                  'msg']}
  let(:claim_possession_hearing_error)      { ['claim_possession_hearing_error',                'msg']}
  let(:claim_order_possession_error)        { ['claim_order_possession_error',                  'msg']}
  let(:claim_tenancy_tenancy_type_error)    { ['claim_tenancy_tenancy_type_error',              'msg']}
  let(:claim_claimant_one_full_name_error)  { ['claim_claimant_one_full_name_error',            'msg']}
  let(:claim_claimant_one_street_error)     { ['claim_claimant_one_street_error',               'msg']}
  let(:claim_claimant_one_postcode_error)   { ['claim_claimant_one_postcode_error',             'msg']}
  let(:claim_claimant_two_full_name_error)  { ['claim_claimant_two_full_name_error',            'msg']}
  let(:claim_claimant_two_street_error)     { ['claim_claimant_two_street_error',               'msg']}
  let(:claim_claimant_two_postcode_error)   { ['claim_claimant_two_postcode_error',             'msg']}
  let(:claim_defendant_one_inhabits_property_error) { ['claim_defendant_one_inhabits_property_error',   'msg']}
  let(:claim_defendant_one_title_error)     { ['claim_defendant_one_title_error',               'msg']}
  let(:claim_defendant_one_full_name_error) { ['claim_defendant_one_full_name_error',           'msg']}
  let(:claim_defendant_one_street_error)    { ['claim_defendant_one_street_error',              'msg']}
  let(:claim_defendant_one_postcode_error)  { ['claim_defendant_one_postcode_error',            'msg']}
  let(:claim_tenancy_confirmed_second_rules_period_applicable_statements_error) { ['claim_tenancy_confirmed_second_rules_period_applicable_statements_error', 'msg']}
  let(:claim_tenancy_confirmed_first_rules_period_applicable_statements_error) { ['claim_tenancy_confirmed_first_rules_period_applicable_statements_error', 'msg']}
  let(:claim_defendant_number_of_defendants_error) { ['claim_defendant_number_of_defendants_error', 'msg'] }
  let(:claim_new_error)                     { ['claim_new_error', 'msg'] }
  let(:claim_property_new_error)            { ['claim_property_new_error', 'msg']}

  let(:base_errors) do
    [
      claim_claimant_number_of_claimants_error,
      claim_property_new_error,
      claim_property_street_error,
      claim_property_postcode_error,
      claim_property_house_error,
      claim_new_error,
      claim_notice_served_by_name_error,
      claim_notice_served_method_error,
      claim_notice_date_served_error,
      claim_notice_expiry_date_error,
      claim_license_multiple_occupation_error,
      claim_deposit_as_money_error,
      claim_possession_hearing_error,
      claim_order_possession_error,
      claim_tenancy_tenancy_type_error,
      claim_claimant_one_full_name_error,
      claim_claimant_one_street_error,
      claim_claimant_one_postcode_error,
      claim_claimant_two_full_name_error,
      claim_claimant_two_street_error,
      claim_claimant_two_postcode_error,
      claim_defendant_one_inhabits_property_error,
      claim_defendant_one_title_error,
      claim_defendant_one_full_name_error,
      claim_defendant_one_street_error,
      claim_defendant_one_postcode_error,
      claim_tenancy_confirmed_second_rules_period_applicable_statements_error,
      claim_tenancy_confirmed_first_rules_period_applicable_statements_error,
      claim_defendant_number_of_defendants_error
    ]
  end

  let(:expected_sorted_errors) do
    [
      claim_property_house_error,
      claim_property_street_error,
      claim_property_postcode_error,
      claim_property_new_error,

      ['claim_num_claimants_error', 'msg'],
      claim_claimant_one_full_name_error,
      claim_claimant_one_street_error,
      claim_claimant_one_postcode_error,
      claim_claimant_two_full_name_error,
      claim_claimant_two_street_error,
      claim_claimant_two_postcode_error,

      ['claim_num_defendants_error', 'msg'],
      claim_defendant_one_title_error,
      claim_defendant_one_full_name_error,
      claim_defendant_one_inhabits_property_error,
      claim_defendant_one_street_error,
      claim_defendant_one_postcode_error,

      claim_notice_served_by_name_error,
      claim_notice_served_method_error,
      claim_notice_date_served_error,
      claim_notice_expiry_date_error,

def base_errors
  [
    ["claim_num_claimants_error",                     "Please say how many claimants there are"],
    ["claim_property_street_error",                   "Enter the full address"],
    ["claim_property_postcode_error",                 "Enter the postcode"],
    ["claim_property_house_error",                    "Please select what kind of property it is"],
    ["claim_notice_served_by_name_error",             "Enter the name of the person who gave the notice"],
    ["claim_notice_served_method_error",              "You must say how the notice was given"],
    ["claim_notice_date_served_error",                "Enter the date notice was served"],
    ["claim_notice_expiry_date_error",                "Enter the date notice ended"],
    ["claim_license_multiple_occupation_error",       "You must say whether or not you have an HMO licence"],
    ["claim_deposit_as_money_error",                  "You must say what kind of deposit the defendant paid"],
    ["claim_possession_hearing_error",                "You must choose whether you wish to attend the possible court hearing"],
    ["claim_order_possession_error",                  "Please tick to confirm that you want to repossess the property"],
    ["claim_tenancy_tenancy_type_error",              "You must say what kind of tenancy agreement you have"],
    ["claim_claimant_one_full_name_error",            "Enter the claimant's full name"],
    ["claim_claimant_one_street_error",               "Enter the claimant's full address"],
    ["claim_claimant_one_postcode_error",             "Enter the claimant's postcode"],
    ["claim_claimant_two_full_name_error",            "Enter claimant 2's full name"],
    ["claim_claimant_two_street_error",               "Enter claimant 2's full address"],
    ["claim_claimant_two_postcode_error",             "Enter claimant 2's postcode"],
    ["claim_defendant_one_inhabits_property_error",   "You must say whether defendant 1's lives in the property"],
    ["claim_defendant_one_title_error",               "Enter defendant 1's title"],
    ["claim_defendant_one_full_name_error",           "Enter defendant 1's full name"],
    ["claim_defendant_one_street_error",              "Enter defendant 1's full address"],
    ["claim_defendant_one_postcode_error",            "Enter defendant 1's postcode"]
  ]
end

  describe '#sequence' do
    it 'should sort the keys in the expected order' do
      errors = double 'ActiveRecord::Errors'
      expect(errors).to receive(:[]).with(:base).and_return(base_errors)
      sorted_error_messages = ErrorMessageSequencer.new.sequence(errors)

def expected_sorted_errors
  [
    ["claim_property_house_error",                    "Please select what kind of property it is"],    
    ["claim_property_street_error",                   "Enter the full address"],
    ["claim_property_postcode_error",                 "Enter the postcode"],
    ["claim_num_claimants_error",                     "Please say how many claimants there are"],
    ["claim_claimant_one_full_name_error",            "Enter the claimant's full name"],
    ["claim_claimant_one_street_error",               "Enter the claimant's full address"],
    ["claim_claimant_one_postcode_error",             "Enter the claimant's postcode"],
    ["claim_claimant_two_full_name_error",            "Enter claimant 2's full name"],
    ["claim_claimant_two_street_error",               "Enter claimant 2's full address"],
    ["claim_claimant_two_postcode_error",             "Enter claimant 2's postcode"],
    ["claim_defendant_one_title_error",               "Enter defendant 1's title"],
    ["claim_defendant_one_full_name_error",           "Enter defendant 1's full name"],
    ["claim_defendant_one_inhabits_property_error",   "You must say whether defendant 1's lives in the property"],
    ["claim_defendant_one_street_error",              "Enter defendant 1's full address"],
    ["claim_defendant_one_postcode_error",            "Enter defendant 1's postcode"],
    ["claim_tenancy_tenancy_type_error",              "You must say what kind of tenancy agreement you have"],
    ["claim_deposit_as_money_error",                  "You must say what kind of deposit the defendant paid"],
    ["claim_license_multiple_occupation_error",       "You must say whether or not you have an HMO licence"],
    ["claim_notice_served_by_name_error",             "Enter the name of the person who gave the notice"],
    ["claim_notice_served_method_error",              "You must say how the notice was given"],
    ["claim_notice_date_served_error",                "Enter the date notice was served"],
    ["claim_notice_expiry_date_error",                "Enter the date notice ended"],
    ["claim_order_possession_error",                  "Please tick to confirm that you want to repossess the property"],
    ["claim_possession_hearing_error",                "You must choose whether you wish to attend the possible court hearing"]
  ]
end
