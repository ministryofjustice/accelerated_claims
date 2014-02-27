class Tenancy < BaseClass

  attr_accessor :start_date
  attr_accessor :latest_agreement_date
  attr_accessor :reissued_for_same_property
  attr_accessor :reissued_for_same_landlord_and_tenant

  validates :start_date, presence: { message: 'must be entered' }

  with_options if: :latest_agreement_date, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] } do |tenancy|
    tenancy.validates :reissued_for_same_property
    tenancy.validates :reissued_for_same_landlord_and_tenant
  end

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
      "agreement_reissued_for_same_property" => reissued_for_same_property,
      "agreement_reissued_for_same_landlord_and_tenant" => reissued_for_same_landlord_and_tenant
    }
  end
end
