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


  def defendant_class_helper(defendant_id)
    if defendant_id > DefendantCollection.max_defendants(js_enabled: false)
      "defendant js-only"
    else
      'defendant'
    end
  end


  def defendant_header defendant_id
    if defendant_id == 1
      "<h3>Defendant #{defendant_id}</h3>".html_safe
    else
      "<h3>Defendant #{defendant_id} <span class='hint hide js-claimanttype'>(optional)</span></h3>".html_safe
    end
  end

  def claimant_header claimant_id
    if claimant_id == 1
      "<h3>Claimant #{claimant_id}</h3>".html_safe
    else
      "<h3>Claimant #{claimant_id} <span class='hint hide js-claimanttype'>(optional)</span></h3>".html_safe
    end
  end

end
