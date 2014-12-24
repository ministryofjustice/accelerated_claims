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
    add_note(part2_text) if applied_for_test?('multiple_occupation', '2')
    add_note(part3_text) if applied_for_test?('part3', '3')
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

  def applied_for_test?(first_part, prefix_number)
    @json["license_#{first_part}"] == 'Yes' &&
        @json["license_part#{prefix_number}_authority"].blank? &&
        @json["license_part#{prefix_number}_day"].blank? &&
        @json["license_part#{prefix_number}_month"].blank? &&
        @json["license_part#{prefix_number}_year"].blank?
  end
end