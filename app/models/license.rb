class License < BaseClass

  attr_accessor :house_in_multiple_occupation
  validates :house_in_multiple_occupation, presence: true, inclusion: { in: ['Yes', 'No'] }

  attr_accessor :house_in_multiple_occupation_authority
  validate :authority_for_house_in_multiple_occupation

  attr_accessor :house_in_multiple_occupation_date

  attr_accessor :housing_act
  validates :housing_act, presence: true, inclusion: { in: ['Yes', 'No'] }

  attr_accessor :housing_act_authority
  validate :authority_for_housing_act

  attr_accessor :housing_act_date

  def authority_for_house_in_multiple_occupation
    if house_in_multiple_occupation.present? && house_in_multiple_occupation == 'Yes'
      errors.add(:house_in_multiple_occupation_authority, "can't be blank") if house_in_multiple_occupation_authority.blank?
    end
  end

  def authority_for_housing_act
    if housing_act.present? && housing_act == 'Yes'
      errors.add(:housing_act_authority, "can't be blank") if housing_act_authority.blank?
    end
  end

  def as_json
    day = '%d'
    month = '%m'
    year = '%Y'

    {
      "authority" => house_in_multiple_occupation_authority,
      "hmo" => house_in_multiple_occupation,
      "hmo_day" => "#{house_in_multiple_occupation_date.strftime(day)}",
      "hmo_month" => "#{house_in_multiple_occupation_date.strftime(month)}",
      "hmo_year" => "#{house_in_multiple_occupation_date.strftime(year)}",
      "housing_act" => housing_act,
      "housing_act_authority" => housing_act_authority,
      "housing_act_date_day" => "#{housing_act_date.strftime(day)}",
      "housing_act_date_month" => "#{housing_act_date.strftime(month)}",
      "housing_act_date_year" => "#{housing_act_date.strftime(year)}"
    }
  end
end
