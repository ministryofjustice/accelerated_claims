class License < BaseClass

  attr_accessor :multiple_occupation
  attr_accessor :issued_under_act_part
  attr_accessor :issued_by
  attr_accessor :issued_date

  validates :multiple_occupation, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'no'] }

  with_options if: :in_multiple_occupation? do |license|
    license.validates :issued_under_act_part, presence: { message: 'must be selected' }, inclusion: { in: ['Part2', 'Part3'] }
    license.validates :issued_by, presence: { message: "can't be blank" }
    license.validates :issued_date, presence: { message: "can't be blank" }
  end

  def in_multiple_occupation?
    multiple_occupation.to_s[/Yes/] ? true : false
  end

  def as_json
    default_values = {
        "multiple_occupation" => 'no',
        "part2_authority" => '',
        "part2_day" => '',
        "part2_month" => '',
        "part2_year" => '',
        "part3" => 'no',
        "part3_authority" => '',
        "part3_day" => '',
        "part3_month" => '',
        "part3_year" => ''
    }

    if in_multiple_occupation?
      case issued_under_act_part
      when 'Part2'
        default_values.merge({
          "multiple_occupation" => 'Yes',
          "part2_authority" => issued_by,
          "part2_day" => day(issued_date),
          "part2_month" => month(issued_date),
          "part2_year" => year(issued_date)
        })
      when 'Part3'
        default_values.merge({
          "multiple_occupation" => 'Yes',
          "part3" => 'Yes',
          "part3_authority" => issued_by,
          "part3_day" => day(issued_date),
          "part3_month" => month(issued_date),
          "part3_year" => year(issued_date)
        })
      end
    else
      default_values
    end
  end

end
