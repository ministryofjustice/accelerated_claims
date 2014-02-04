class Notice
  include ActiveModel::Model

  attr_accessor :served_by
  validates :served_by, presence: true, length: { maximum: 40 }

  attr_accessor :date_served
  validates :date_served, presence: true

  attr_accessor :expiry_date
  validates :expiry_date, presence: true
end
