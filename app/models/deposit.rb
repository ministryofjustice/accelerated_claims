class Deposit < BaseClass

  attr_accessor :received
  validates :received, inclusion: { in: ['Yes', 'No'] }

  attr_accessor :ref_number

  attr_accessor :as_property
  validates :as_property, inclusion: { in: ['Yes', 'No'] }
end
