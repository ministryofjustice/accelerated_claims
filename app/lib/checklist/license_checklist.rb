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
    if @json['license_multiple_occupation'] == 'Applied'
      case @json['license_part3']
      when 'Yes'
        add_note(part3_text)
      when 'No'
        add_note(part2_text)
      else
        full_text if other_options_blank?
      end
    end
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
  
end
