class Tenancy < BaseClass

  attr_accessor :start_date
  validates :start_date, presence: true

  attr_accessor :latest_agreement_date

  attr_accessor :agreement_reissued_for_same_property
  validates :agreement_reissued_for_same_property, inclusion: { in: [true, false] }

  attr_accessor :agreement_reissued_for_same_landlord_and_tenant
  validates :agreement_reissued_for_same_landlord_and_tenant, inclusion: { in: [true, false] }

  def as_json
    day = '%d'
    month = '%m'
    year = '%Y'

    {
      "start_date_day" => "#{start_date.strftime(day)}",
      "start_date_month" => "#{start_date.strftime(month)}",
      "start_date_year" => "#{start_date.strftime(year)}",
      "latest_agreement_date_day" => "#{latest_agreement_date.strftime(day)}",
      "latest_agreement_date_month" => "#{latest_agreement_date.strftime(month)}",
      "latest_agreement_date_year" => "#{latest_agreement_date.strftime(year)}",
      "agreement_reissued_for_same_property" => agreement_reissued_for_same_property,
      "agreement_reissued_for_same_landlord_and_tenant" => agreement_reissued_for_same_landlord_and_tenant
    }
  end
end
