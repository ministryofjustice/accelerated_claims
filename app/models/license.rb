class License < BaseClass

  attr_accessor :multiple_occupation
  attr_accessor :issued_under_act_part_yes
  attr_accessor :issued_under_act_part_applied
  attr_accessor :issued_by
  attr_accessor :issued_date

  validates :multiple_occupation, presence: { message: 'You must say whether or not you have an HMO licence' }, inclusion: { in: ['Yes', 'No', 'Applied'] }

  with_options if: :in_multiple_occupation? do |license|
    license.validates :issued_under_act_part_yes, presence: { message: 'Choose which kind of HMO licence you have' }, inclusion: { in: ['Part2', 'Part3'] }
    license.validates :issued_by, presence: { message: "Enter the local authority that issued the HMO licence" }, length: { maximum: 70 }
    license.validates :issued_date, presence: { message: "Enter the date the licence was issued" }
    validates_with DateValidator, :fields => [:issued_date]
  end

  with_options if: :hmo_licence_applied_for? do |license|
    license.validates :issued_under_act_part_applied, presence: { message: 'You must select the type of HMO licence that you have applied for' }, inclusion: { in: ['Part2', 'Part3'] }
    license.validates :issued_by, absence: { message: "Must be blank if HMO licence applied for" }
    license.validates :issued_date, absence: { message: "Must be blank if HMO licence applied for" }
  end

  with_options if: :not_in_multiple_occupation? do |license|
    license.validates :issued_by, absence: { message: "Must be blank if you replied No to 'Do you have an HMO licence'"}
    license.validates :issued_date, absence: { message: "Must be blank if you replied No to 'Do you have an HMO licence'"}
    license.validates :issued_under_act_part_applied, absence: { message: "Must be blank if you replied No to 'Do you have an HMO licence'"}
    license.validates :issued_under_act_part_yes, absence: { message: "Must be blank if you replied No to 'Do you have an HMO licence'"}
  end


 

  def not_in_multiple_occupation?
    multiple_occupation.to_s[/No/] ? true : false
  end

  def in_multiple_occupation?
    multiple_occupation.to_s[/Yes/] ? true : false
  end


  def hmo_licence_applied_for?
    multiple_occupation.to_s[/Applied/] ? true : false
  end

  def as_json
    default_values = {
      "multiple_occupation" => 'No',
      "part2_authority" => '',
      "part2_day" => '',
      "part2_month" => '',
      "part2_year" => '',
      "part3" => 'No',
      "part3_authority" => '',
      "part3_day" => '',
      "part3_month" => '',
      "part3_year" => ''
    }

    if in_multiple_occupation? 
      case issued_under_act_part_yes
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
          "multiple_occupation" => 'No',
          "part3" => 'Yes',
          "part3_authority" => issued_by,
          "part3_day" => day(issued_date),
          "part3_month" => month(issued_date),
          "part3_year" => year(issued_date)
        })
      end
    elsif hmo_licence_applied_for?
      case issued_under_act_part_applied
      when 'Part2'
        default_values.merge({
          "multiple_occupation" => 'Yes',
          "part2_authority" => '',
          "part2_day" => '',
          "part2_month" => '',
          "part2_year" => ''
        })
      when 'Part3'
        default_values.merge({
          "multiple_occupation" => 'No',
          "part3" => 'Yes',
          "part3_authority" => '',
          "part3_day" => '',
          "part3_month" => '',
          "part3_year" => ''
        })
      end
    else
      default_values
    end
  end

end
