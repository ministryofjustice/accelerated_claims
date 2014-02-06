class Order < BaseClass

  attr_accessor :possession
  validates :possession, presence: true

  attr_accessor :cost
  validates :cost, presence: true
end
