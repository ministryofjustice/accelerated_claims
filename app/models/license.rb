class License < BaseClass

  attr_accessor :multiple_occupation
  validates :multiple_occupation, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }

  attr_accessor :multiple_occupation_authority
  validate :authority_for_multiple_occupation

  attr_accessor :multiple_occupation_date

  attr_accessor :housing_act
  validates :housing_act, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }

  attr_accessor :housing_act_authority
  validate :authority_for_housing_act

  attr_accessor :housing_act_date

  def authority_for_multiple_occupation
    if multiple_occupation.present? && multiple_occupation == 'Yes'
      errors.add(:multiple_occupation_authority, "can't be blank") if multiple_occupation_authority.blank?
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
      "authority" => multiple_occupation_authority,
      "hmo" => multiple_occupation,
      "hmo_day" => "#{multiple_occupation_date.strftime(day)}",
      "hmo_month" => "#{multiple_occupation_date.strftime(month)}",
      "hmo_year" => "#{multiple_occupation_date.strftime(year)}",
      "housing_act" => housing_act,
      "housing_act_authority" => housing_act_authority,
      "housing_act_date_day" => "#{housing_act_date.strftime(day)}",
      "housing_act_date_month" => "#{housing_act_date.strftime(month)}",
      "housing_act_date_year" => "#{housing_act_date.strftime(year)}"
    }
  end
end
