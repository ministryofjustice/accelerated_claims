class DemotedTenancy < BaseClass

  attr_accessor :demoted_tenancy
  attr_accessor :demotion_order_date
  attr_accessor :demotion_order_court

  validates :demoted_tenancy, presence: { message: 'must be selected' }
  validates :demoted_tenancy, inclusion: { in: ['Yes', 'No'] }

  with_options if: :demoted_tenancy? do |tenancy|
    tenancy.validates :demotion_order_date, presence: { message: 'must be selected' }
    tenancy.validates :demotion_order_court, presence: { message: 'must be present' }
  end

  with_options if: -> demoted_tenancy { demoted_tenancy.demoted_tenancy == 'No' } do |tenancy|
    err = "can't be provided if it's not for a demoted tenancy"
    tenancy.validates :demotion_order_date, absence: { message: err }
    tenancy.validates :demotion_order_court, absence: { message: err }
  end

  validates_with DateValidator, :fields => [:demotion_order_date]

  def demoted_tenancy?
    demoted_tenancy == 'Yes'
  end

  def date_and_court_set?
    (!demotion_order_date.blank? && !demotion_order_court.blank?)
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
