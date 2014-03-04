class DemotedTenancy < BaseClass

  attr_accessor :demoted_tenancy
  attr_accessor :demotion_order_date
  attr_accessor :demotion_order_court

  validates :demoted_tenancy, inclusion: { in: ['Yes', 'No'] }

  with_options if: :is_demoted_tenancy do |tenancy|
    tenancy.validates :demotion_order_date, presence: { message: 'must be selected' }
    tenancy.validates :demotion_order_court, presence: { message: 'must be present' }
  end

  def is_demoted_tenancy
    demoted_tenancy == 'Yes'
  end

  def as_json
    {
      "demoted_tenancy" => demoted_tenancy,
      "demotion_order_date_day" => day(demotion_order_date),
      "demotion_order_date_month" => month(demotion_order_date),
      "demotion_order_date_year" => year(demotion_order_date),
      "demotion_order_court" => demotion_order_court
    }
  end
end

