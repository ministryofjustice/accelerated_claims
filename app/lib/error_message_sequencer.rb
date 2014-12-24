class ErrorMessageSequencer

  SECTION_ORDER = [
    'claim_property',
    'claim_claimant',
    'claim_defendant',
    'claim_notice',
    'claim_tenancy',
    'claim_deposit',
    'claim_license',
    'claim_order',
    'claim_possession',
    'claim_court'
  ]

  FIELD_ORDER = {
    'claim_property' => [
      'claim_property_house_error',
      'claim_property_street_error',
      'claim_property_postcode_error'
    ],

    'claim_claimant' => [
      'claim_claimant_type_error',
      'claim_claimant_number_of_claimants_error'] +
        (1..4).to_a.collect do |i|
          ["claim_claimant_#{i}_title_error",
          "claim_claimant_#{i}_full_name_error",
          "claim_claimant_#{i}_street_error",
          "claim_claimant_#{i}_postcode_error"]
        end.flatten +
      [
      'claim_claimant_contact_email_error',
      'claim_claimant_contact_phone_error',
      'claim_claimant_contact_full_name_error',
      'claim_claimant_contact_postcode_error'
    ],

    'claim_defendant' => [
      'claim_defendant_number_of_defendants_error'] +
       (1..20).to_a.collect do |i|
          [
          "claim_defendant_#{i}_title_error",
          "claim_defendant_#{i}_full_name_error",
          "claim_defendant_#{i}_inhabits_property_error",
          "claim_defendant_#{i}_street_error",
          "claim_defendant_#{i}_postcode_error"]
        end.flatten,

    'claim_notice' => [
      'claim_notice_served_by_name_error',
      'claim_notice_served_method_error',
      'claim_notice_date_served_error',
      'claim_notice_expiry_date_error',
    ],

    'claim_tenancy' => [
      'claim_tenancy_tenancy_type_error',
      'claim_tenancy_assured_shorthold_tenancy_notice_served_by_error',
      'claim_tenancy_assured_shorthold_tenancy_notice_served_date_error',
      'claim_tenancy_confirmed_first_rules_period_applicable_statements_error',
      'claim_tenancy_confirmed_second_rules_period_applicable_statements_error',
      'claim_tenancy_demotion_order_date_error',
      'claim_tenancy_demotion_order_court_error',
      'claim_tenancy_previous_tenancy_type_error',
      'claim_tenancy_start_date_error',
    ],

    'claim_deposit' => [
      'claim_deposit_received_error',
      'claim_deposit_as_money_error',
    ],

    'claim_license' => [
      'claim_license_multiple_occupation_error',
      'claim_license_issued_under_act_part_applied_error',
      'claim_license_issued_by_error',
      'claim_license_issued_under_act_part_yes_error',
      'claim_license_issued_date_error',
    ],

    'claim_order' => [
      'claim_order_possession_error',
    ],

    'claim_possession' => [
      'claim_possession_hearing_error',
    ],

    'claim_court' => [
      'claim_court_court_name_error',
      'claim_court_street_error',
      'claim_court_postcode_error'
    ]
  }

  # errors is an array of two-element arrays.
  # The first element in the array is the key, e.g. 'claim_property_house_error'
  # this is what we use to determine the order.
  def sequence(errors)
    errors = errors[:base]
    errors.each do |pair|
      pair[0] = update_pair(pair[0])
    end
    sorted = errors.sort { |a, b| comparison_number(a[0], b[0]) }
    sorted.each do |pair|
      pair[0] = reset_pair(pair[0])
    end
    sorted
  end

  private

  def update_pair(start)
    case start
    when 'claim_num_claimants_error'
      result = 'claim_claimant_number_of_claimants_error'
    when 'claim_num_defendants_error'
      result = 'claim_defendant_number_of_defendants_error'
    else
      result = start
    end
    result
  end

  def reset_pair(start)
    case start
    when 'claim_claimant_number_of_claimants_error'
      result = 'claim_num_claimants_error'
    when 'claim_defendant_number_of_defendants_error'
      result = 'claim_num_defendants_error'
    else
      result = start
    end
    result
  end

  # e.g. returns 'claim_defendant' if given 'claim_defendant_1_title_error'
  def section_prefix error
    error.split('_')[0..1].join('_')
  end

  def comparison_number error1, error2
    section1 = section_prefix error1
    section2 = section_prefix error2

    section_comparison = compare SECTION_ORDER.index(section1), SECTION_ORDER.index(section2)

    if same_section?(section_comparison)
      compare_fields(section1, error1, error2)
    else
      section_comparison
    end
  end

  def same_section? section_comparison
    section_comparison == 0
  end

  def compare_fields section, error1, error2
    if section = FIELD_ORDER[section]
      index1 = section.index(error1)
      index2 = section.index(error2)
      comparison = compare(index1, index2)
      comparison
    else
      -1
    end
  end

  def compare index1, index2
    if index1.present? && index2.present?
      if index1 == index2
        0
      else
        (index2 - index1 > 0) ? -1 : 1
      end
    elsif index1
      -1
    elsif index2
      1
    else
      0
    end
  end

end
