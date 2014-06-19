class LicenseChecklist
  def initialize(json)
    @json = json
  end

  def add
    add_license_text
    @json
  end

  private

  def add_license_text
    add_note(part2_text) if part2_applied_for?
    add_note(part3_text) if part3_applied_for?
  end

  def add_note text
    @json['required_documents'].concat text
  end

  def part2_text
    "- Evidence of your HMO license application issued under part 2 of the Housing Act 2004 - marked 'D'\n\n"
  end

  def part3_text
    "- Evidence of your HMO license application issued under part 3 of the Housing Act 2004 - marked 'E'\n\n"
  end


  def part2_applied_for?
    @json['license_multiple_occupation'] == 'Yes' &&
      !@json['license_part2_authority'].present? &&
      !@json['license_part2_day'].present? &&
      !@json['license_part2_month'].present? &&
      !@json['license_part2_year'].present? &&
      !@json['license_part_year'].present?
  end


  def part3_applied_for?
    @json['license_part3'] == 'Yes' && 
      !@json['part3_authority'].present? &&
      !@json['part3_day'].present? &&
      !@json['part3_month'].present? &&
      !@json['part3_year'].present?
  end

end