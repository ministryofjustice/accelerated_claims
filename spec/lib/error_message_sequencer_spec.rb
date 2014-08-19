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
  let(:claim_claimant_1_full_name_error)    { ['claim_claimant_1_full_name_error',            'msg']}
  let(:claim_claimant_1_street_error)       { ['claim_claimant_1_street_error',               'msg']}
  let(:claim_claimant_1_postcode_error)     { ['claim_claimant_1_postcode_error',             'msg']}
  let(:claim_claimant_2_full_name_error)    { ['claim_claimant_2_full_name_error',            'msg']}
  let(:claim_claimant_2_street_error)       { ['claim_claimant_2_street_error',               'msg']}
  let(:claim_claimant_2_postcode_error)     { ['claim_claimant_2_postcode_error',             'msg']}
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
      claim_claimant_1_full_name_error,
      claim_claimant_1_street_error,
      claim_claimant_1_postcode_error,
      claim_claimant_2_full_name_error,
      claim_claimant_2_street_error,
      claim_claimant_2_postcode_error,
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
      claim_claimant_1_full_name_error,
      claim_claimant_1_street_error,
      claim_claimant_1_postcode_error,
      claim_claimant_2_full_name_error,
      claim_claimant_2_street_error,
      claim_claimant_2_postcode_error,

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

      claim_tenancy_tenancy_type_error,
      claim_tenancy_confirmed_first_rules_period_applicable_statements_error,
      claim_tenancy_confirmed_second_rules_period_applicable_statements_error,

      claim_deposit_as_money_error,
      claim_license_multiple_occupation_error,
      claim_order_possession_error,
      claim_possession_hearing_error,

      claim_new_error
    ]
  end

  describe '#sequence' do
    it 'should sort the keys in the expected order' do
      errors = double 'ActiveRecord::Errors'
      expect(errors).to receive(:[]).with(:base).and_return(base_errors)
      sorted_error_messages = ErrorMessageSequencer.new.sequence(errors)

      expected_sorted_errors.each_with_index do |expected_error, index|
        expect(sorted_error_messages[index][0]).to eq expected_error[0]
      end
    end
  end
end