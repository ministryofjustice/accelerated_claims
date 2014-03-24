class Deposit < BaseClass

  attr_accessor :received
  validates :received, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }

  attr_accessor :information_given_date

  attr_accessor :ref_number

  attr_accessor :as_property
  validates :as_property, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }

  with_options if: -> deposit { deposit.received == 'No'} do |deposit|
    err = 'can\'t be provided if there is no deposit given'
    deposit.validates :information_given_date, absence: { message: err }
    deposit.validates :ref_number, absence: { message: err }
  end

  def as_json
    json = super
    json = split_date :information_given_date, json
    json
  end
end
