class Deposit
  include ActiveModel::Model

  attr_accessor :received
  validates :received, inclusion: { in: [true, false] }

  attr_accessor :ref_number

  attr_accessor :as_property
  validates :as_property, inclusion: { in: [true, false] }
end
