class DemotedTenancy < BaseClass

  attr_accessor :demoted_tenancy
  attr_accessor :demotion_order_date
  attr_accessor :demotion_order_court

  validates :demoted_tenancy, presence: { message: 'must be selected' }
  validates :demoted_tenancy, inclusion: { in: ['Yes', 'no'] }

  with_options if: :is_demoted_tenancy? do |tenancy|
    tenancy.validates :demotion_order_date, presence: { message: 'must be selected' }
    tenancy.validates :demotion_order_court, presence: { message: 'must be present' }
  end

  def is_demoted_tenancy?
    demoted_tenancy == 'Yes'
  end

  def as_json
    {
      "demoted_tenancy" => demoted_tenancy,
      "demotion_order_date_day" => day(demotion_order_date),
      "demotion_order_date_month" => month(demotion_order_date),
      "demotion_order_date_year" => year(demotion_order_date),
      "demotion_order_court" => short_court_name
    }
  end

  private

  def short_court_name
    demotion_order_court.to_s.sub(/ County Court/,'')
  end
end

