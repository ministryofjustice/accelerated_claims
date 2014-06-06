class Notice < BaseClass

  attr_accessor :served_by_name
  validates :served_by_name, presence: { message: 'must be entered' }, length: { maximum: 40 }

  attr_accessor :served_method
  validates :served_method, presence: { message: 'must be entered' }, length: { maximum: 40 }

  attr_accessor :date_served
  validates :date_served, presence: { message: 'must be entered' }

  attr_accessor :expiry_date
  validates :expiry_date, presence: { message: 'must be entered' }

  validates_with DateValidator, :fields => [:date_served, :expiry_date]

  validate :expiry_date_must_be_after_served_date

  def as_json
    json = super
    json["served_by"] = "#{json["served_by_name"]}, #{json["served_method"]}"
    ["served_by_name", "served_method"].each { |attr| json.delete attr }
    json = split_date :date_served, json
    json = split_date :expiry_date, json
    json
  end
end



def expiry_date_must_be_after_served_date
  if date_served.is_a?(Date) && expiry_date.is_a?(Date)
    unless expiry_date > date_served
      errors.add(:expiry_date, "must be later than the Date notice served ")
    end
  end
end