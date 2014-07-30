class Notice < BaseClass

  attr_accessor :notice_served

  attr_accessor :served_by_name
  validates :served_by_name, presence: { message: 'Enter the name of the person who gave the notice' }, length: { maximum: 40 }

  attr_accessor :served_method
  validates :served_method, presence: { message: 'You must say how the notice was given' }, length: { maximum: 40 }

  attr_accessor :date_served
  validates :date_served, presence: { message: 'Enter the date notice was served' }

  attr_accessor :expiry_date
  validates :expiry_date, presence: { message: 'Enter the date notice ended' }

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

  def expiry_date_must_be_after_served_date
    if date_served.is_a?(Date) && expiry_date.is_a?(Date)
      if expiry_date < (date_served + 2.months - 1.day)
        errors.add(:expiry_date, "The date notice ended must be at least 2 months after the date notice served")
      end
    end
  end

end