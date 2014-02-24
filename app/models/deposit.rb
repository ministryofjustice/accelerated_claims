class Deposit < BaseClass

  attr_accessor :received
  validates :received, presence: true, inclusion: { in: ['Yes', 'No'] }

  attr_accessor :ref_number

  attr_accessor :as_property
  validates :as_property, presence: true, inclusion: { in: ['Yes', 'No'] }
end
