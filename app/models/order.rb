class Order < BaseClass

  attr_accessor :possession
  validates :possession, presence: true, inclusion: { in: ['Yes'] }

  attr_accessor :cost
  validates :cost, presence: true
end
