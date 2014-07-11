class ErrorMessageSequencer

  @@ordered_keys = {
      'claim_property_house_error'                  => 100,
      'claim_property_street_error'                 => 120,
      'claim_property_postcode_error'               => 140,
      'claim_num_claimants_error'                   => 210,
      'claim_claimant_one_full_name_error'          => 220,
      'claim_claimant_one_street_error'             => 230,
      'claim_claimant_one_postcode_error'           => 240,
      'claim_claimant_two_full_name_error'          => 250,
      'claim_claimant_two_street_error'             => 260,
      'claim_claimant_two_postcode_error'           => 270,
      'claim_num_defendants_error'                  => 310,
      'claim_defendant_one_title_error'             => 320,
      'claim_defendant_one_full_name_error'         => 330,
      'claim_defendant_one_inhabits_property_error' => 332,
      'claim_defendant_one_street_error'            => 340,
      'claim_defendant_one_postcode_error'          => 350,
      'claim_defendant_two_title_error'             => 360,
      'claim_defendant_two_full_name_error'         => 370,
      'claim_defendant_two_street_error'            => 380,
      'claim_defendant_two_postcode_error'          => 390,
      'claim_tenancy_tenancy_type_error'            => 410,
      'claim_deposit_received_error'                => 510,
      'claim_deposit_as_money_error'                => 520,
      'claim_license_multiple_occupation_error'     => 610,
      'claim_notice_served_method_error'            => 730,
      'claim_notice_served_by_name_error'           => 740,
      'claim_notice_served_method_error'            => 750,
      'claim_notice_date_served_error'              => 760,
      'claim_notice_expiry_date_error'              => 770,
      'claim_order_possession_error'                => 810,
      'claim_possession_hearing_error'              => 820
  }


  # errors is an array of two-element arrays.  The first element in the array is the key, e.g. 'claim_property_house_error', and this is what we use to determine the order.
  def sequence(errors)
    errors[:base].sort { |a, b| sequence_value(a) <=> sequence_value(b) }
  end

  private

  def sequence_value(error_message_pair)
    error_key, error_message = error_message_pair
    result = 999
    @@ordered_keys.keys.each do | ordered_key |
      if error_key == ordered_key
        result = @@ordered_keys[ordered_key]
        break
      end
    end
    if result == 999
      error_message << " >>>>>>>>> #{error_key} <<<<<<<"
    end
    result
  end

end

