module ApplicationHelper

  def link_reference_for_error field
    case field
    when /claim_tenancy_confirmed_(first|second)_rules_period_applicable_statements/
      'read-statements'
    when /claim_claimant_number_of_claimants_error/
      'claim_num_claimants_error'
    when /claim_defendant_number_of_defendants_error/
      'claim_num_defendants_error'
    else
      field
    end
  end

end
