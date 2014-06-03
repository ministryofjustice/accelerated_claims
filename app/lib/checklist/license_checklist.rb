# -*- coding: utf-8 -*-
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
    if @json['license_multiple_occupation'] == 'Yes'
      (@json['license_part3'] == 'Yes') ? myappend(part3_text) : myappend(part2_text)
    else
      full_text if other_options_blank?
    end
  end

  def myappend text
    @json['required_documents'] = @json['required_documents'].concat text
  end

  def part2_text
    "Evidence of your HMO license application issued under part 2 of Housing Act 2004 - marked 'D'"
  end

  def part3_text
    "Evidence of your HMO license application issued under part 3 of Housing Act 2004 - marked 'E'"
  end

  def full_text
    @json['required_documents'] = @json['required_documents'].concat "Evidence of your HMO license application

• if issued under part 2 of Housing Act 2004 - marked 'D'
• if issued under part 3 of Housing Act 2004 - marked 'E'"
  end

  def other_options_blank?
    !@json['license_part2_authority'].present? &&
      !@json['license_part2_day'].present? &&
      !@json['license_part2_month'].present? &&
      !@json['license_part2_year'].present? &&
      !@json['license_part_year'].present? &&
      !@json['part3'].present? &&
      !@json['part3_authority'].present? &&
      !@json['part3_day'].present? &&
      !@json['part3_month'].present? &&
      !@json['part3_year'].present?
  end
end