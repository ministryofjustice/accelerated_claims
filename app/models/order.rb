class Order
  include ActiveModel::Model

  attr_accessor :possession
  validates :possession, presence: true

  attr_accessor :cost
  validates :cost, presence: true
end
