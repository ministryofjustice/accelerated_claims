class Order < BaseClass

  attr_accessor :possession
  validates :possession, presence: true
  validates :possession, inclusion: { in: ['Yes'], message: 'Please tick to confirm that you want to repossess the property' }

  attr_accessor :cost
  validates :cost, presence: true
  validates :cost, inclusion: { in: ['Yes', 'No'] }
end
