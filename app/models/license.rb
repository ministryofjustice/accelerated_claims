class License < BaseClass

  attr_accessor :multiple_occupation
  attr_accessor :issued_under_act_part
  attr_accessor :issued_by
  attr_accessor :issued_date

  validates :multiple_occupation, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }

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
        "hmo" => 'No',
        "authority" => '',
        "hmo_day" => '',
        "hmo_month" => '',
        "hmo_year" => '',
        "housing_act" => 'No',
        "housing_act_authority" => '',
        "housing_act_date_day" => '',
        "housing_act_date_month" => '',
        "housing_act_date_year" => ''
    }

    if in_multiple_occupation?
      case issued_under_act_part
      when 'Part2'
        default_values.merge({
          "hmo" => 'Yes',
          "authority" => issued_by,
          "hmo_day" => day(issued_date),
          "hmo_month" => month(issued_date),
          "hmo_year" => year(issued_date)
        })
      when 'Part3'
        default_values.merge({
          "housing_act" => 'Yes',
          "housing_act_authority" => issued_by,
          "housing_act_date_day" => day(issued_date),
          "housing_act_date_month" => month(issued_date),
          "housing_act_date_year" => year(issued_date)
        })
      end
    else
      default_values
    end
  end

end
