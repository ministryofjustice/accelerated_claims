class Deposit < BaseClass

  attr_accessor :received
  validates :received, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }

  attr_accessor :information_given_date

  attr_accessor :ref_number

  attr_accessor :as_property
  validates :as_property, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }

  def as_json
    json = super
    json.delete('information_given_date')
    json.merge({
      "information_given_date_day" => day(information_given_date),
      "information_given_date_month" => month(information_given_date),
      "information_given_date_year" => year(information_given_date)
    }
    )
  end
end
