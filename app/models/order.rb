class Order < BaseClass

  attr_accessor :possession
  validates :possession, presence: true
  validates :possession, inclusion: { in: ['Yes'], message: 'must be checked' }

  attr_accessor :cost
  validates :cost, presence: true
  validates :cost, inclusion: { in: ['Yes', 'No'] }
end
