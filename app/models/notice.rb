class Notice < BaseClass

  attr_accessor :served_by
  validates :served_by, presence: true, length: { maximum: 40 }

  attr_accessor :date_served
  validates :date_served, presence: true

  attr_accessor :expiry_date
  validates :expiry_date, presence: true

  def as_json
    day = '%d'
    month = '%m'
    year = '%G'

    d = Date.parse date_served
    e = Date.parse expiry_date
    {
     "served_by" => "#{served_by}",
     "date_served_day" => "#{d.strftime(day)}",
     "date_served_month" => "#{d.strftime(month)}",
     "date_served_year" => "#{d.strftime(year)}",
     "expiry_date_day" => "#{e.strftime(day)}",
     "expiry_date_month" => "#{e.strftime(month)}",
     "expiry_date_year" => "#{e.strftime(year)}"
    }
  end
end
