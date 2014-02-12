class License < BaseClass

  attr_accessor :hmo
  validates :hmo, inclusion: { in: [true, false] }

  attr_accessor :authority
  validate :authority_for_hmo

  attr_accessor :hmo_date

  attr_accessor :housing_act
  validates :housing_act, inclusion: { in: [true, false] }

  attr_accessor :housing_act_authority
  validate :authority_for_housing_act

  attr_accessor :housing_act_date

  def authority_for_hmo
    if hmo.present?
      errors.add(:authority, "can't be blank") if authority.blank?
    end
  end

  def authority_for_housing_act
    if housing_act.present?
      errors.add(:housing_act_authority, "can't be blank") if housing_act_authority.blank?
    end
  end

  def as_json
    day = '%d'
    month = '%m'
    year = '%Y'

    hdate = Date.strptime hmo_date, "#{day} #{month} #{year}"
    act = Date.strptime housing_act_date, "#{day} #{month} #{year}"

    {
      "authority" => authority,
      "hmo" => hmo,
      "hmo_day" => "#{hdate.strftime(day)}",
      "hmo_month" => "#{hdate.strftime(month)}",
      "hmo_year" => "#{hdate.strftime(year)}",
      "housing_act" => housing_act,
      "housing_act_authority" => housing_act_authority,
      "housing_act_date_day" => "#{act.strftime(day)}",
      "housing_act_date_month" => "#{act.strftime(month)}",
      "housing_act_date_year" => "#{act.strftime(year)}"
    }
  end
end
