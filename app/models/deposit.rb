class Deposit < BaseClass

  attr_accessor :received
  validates :received, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }

  attr_accessor :information_given_date

  attr_accessor :ref_number

  attr_accessor :as_property
  validates :as_property, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }

  def as_json
    json = super
    json = split_date :information_given_date, json
    json
  end
end
