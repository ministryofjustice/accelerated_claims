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
    {
      "authority" => multiple_occupation_authority,
      "hmo" => multiple_occupation,
      "hmo_day" => day(multiple_occupation_date),
      "hmo_month" => month(multiple_occupation_date),
      "hmo_year" => year(multiple_occupation_date),
      "housing_act" => housing_act,
      "housing_act_authority" => housing_act_authority,
      "housing_act_date_day" => day(housing_act_date),
      "housing_act_date_month" => month(housing_act_date),
      "housing_act_date_year" => year(housing_act_date)
    }
  end

end
