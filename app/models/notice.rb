class Notice < BaseClass

  attr_accessor :served_by
  validates :served_by, presence: { message: 'must be entered' }, length: { maximum: 40 }

  attr_accessor :date_served
  validates :date_served, presence: { message: 'must be entered' }

  attr_accessor :expiry_date
  validates :expiry_date, presence: { message: 'must be entered' }

  def as_json
    json = super
    json = split_date :date_served, json
    json = split_date :expiry_date, json
    json
  end
end
