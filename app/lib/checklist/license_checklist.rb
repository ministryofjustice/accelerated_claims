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
    add_note(part2_text) if applied_for_test?('license_multiple_occupation', 'license_part2')
    add_note(part3_text) if applied_for_test?('license_part3', 'license_part3')
  end

  def add_note text
    @json['required_documents'].concat text
  end

  def part2_text
    "- evidence of your HMO licence application - marked 'D'\n\n"
  end

  def part3_text
    "- evidence of your HMO licence application - marked 'E'\n\n"
  end

  def applied_for_test?(first_part, part_prefix)
    @json[first_part] == 'Yes' &&
        @json["#{part_prefix}_authority"].blank? &&
        @json['license_part3_day'].blank? &&
        @json['license_part3_month'].blank? &&
        @json['license_part3_year'].blank?
  end
end