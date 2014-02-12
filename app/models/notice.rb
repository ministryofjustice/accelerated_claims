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
    year = '%Y'
    
    {
     "served_by" => "#{served_by}",
     "date_served_day" => "#{date_served.strftime(day)}",
     "date_served_month" => "#{date_served.strftime(month)}",
     "date_served_year" => "#{date_served.strftime(year)}",
     "expiry_date_day" => "#{expiry_date.strftime(day)}",
     "expiry_date_month" => "#{expiry_date.strftime(month)}",
     "expiry_date_year" => "#{expiry_date.strftime(year)}"
    }
  end
end
