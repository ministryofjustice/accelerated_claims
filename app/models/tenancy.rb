class Tenancy < BaseClass

  attr_accessor :demoted_tenancy

  attr_accessor :start_date
  attr_accessor :latest_agreement_date
  attr_accessor :reissued_for_same_property
  attr_accessor :reissued_for_same_landlord_and_tenant
  attr_accessor :assured_shorthold_tenancy_notice_served_by
  attr_accessor :assured_shorthold_tenancy_notice_served_date

  validates :start_date, presence: { message: 'must be entered' }, unless: :demoted_tenancy

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
      "latest_agreement_date_day" => day(latest_agreement_date),
      "latest_agreement_date_month" => month(latest_agreement_date),
      "latest_agreement_date_year" => year(latest_agreement_date),
      "agreement_reissued_for_same_property" => reissued_for_same_property,
      "agreement_reissued_for_same_landlord_and_tenant" => reissued_for_same_landlord_and_tenant,
      'assured_shorthold_tenancy_notice_served_by' => assured_shorthold_tenancy_notice_served_by,
      'assured_shorthold_tenancy_notice_served_date_day' => day(assured_shorthold_tenancy_notice_served_date),
      'assured_shorthold_tenancy_notice_served_date_month' => month(assured_shorthold_tenancy_notice_served_date),
      'assured_shorthold_tenancy_notice_served_date_year' => year(assured_shorthold_tenancy_notice_served_date)
    }
  end
end
