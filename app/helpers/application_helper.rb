module ApplicationHelper

  def link_reference_for_error field
    case field
    # links applicable statement errors to top of applicable statement section
    when /claim_tenancy_confirmed_(first|second)_rules_period_applicable_statements/
      'read-statements'
    when /claim_tenancy_assured_shorthold_tenancy_notice_served_(by|date)_error/
      'read-statements'
      
    # renames number fields to match input field name
    when /claim_claimant_number_of_claimants_error/
      'claim_num_claimants_error'
    when /claim_defendant_number_of_defendants_error/
      'claim_num_defendants_error'
    else
      field
    end
  end


  def add_optional text
    %Q[#{text}<span class="hint"> (Optional)</span>].html_safe
  end

  def add_optional_nonjs text
    %Q[#{text}<span class="hint nonjs"> (Optional)</span>].html_safe
  end


  def address_error_message
    "The address cannot have more than 4 lines in order to fit in the box on the pre-printed form.  Please reformat the address so that it has 4 lines or less."
  end

end
