class DemotedTenancy
  include ActiveModel::Model

  attr_accessor :assured
  validates :assured, presence: true

  attr_accessor :demotion_order_date
  validates :demotion_order_date, presence: true

  attr_accessor :county_court
  validates :county_court, presence: true, length: { maximum: 60 }
end
