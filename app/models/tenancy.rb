class Tenancy < BaseClass

  attr_accessor :start_date
  validates :start_date, presence: { message: 'must be entered' }

  attr_accessor :latest_agreement_date

  attr_accessor :reissued_for_same_property
  validates :reissued_for_same_property, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }

  attr_accessor :reissued_for_same_landlord_and_tenant
  validates :reissued_for_same_landlord_and_tenant, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }

  def as_json
    day = '%d'
    month = '%m'
    year = '%Y'

    {
      "start_date_day" => "#{start_date.strftime(day)}",
      "start_date_month" => "#{start_date.strftime(month)}",
      "start_date_year" => "#{start_date.strftime(year)}",
      "latest_agreement_date_day" => day(latest_agreement_date),
      "latest_agreement_date_month" => month(latest_agreement_date),
      "latest_agreement_date_year" => year(latest_agreement_date),
      "agreement_reissued_for_same_property" => reissued_for_same_property,
      "agreement_reissued_for_same_landlord_and_tenant" => reissued_for_same_landlord_and_tenant
    }
  end
end
