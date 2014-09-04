class Order < BaseClass

  attr_accessor :possession
  validates :possession, presence: true
  validates :possession, inclusion: { in: ['Yes'] }

  before_validation :set_possession_to_yes

  attr_accessor :cost
  validates :cost, presence: { message: 'You must choose whether you wish to ask the defendant to pay the cost of this claim' }
  validates :cost, inclusion: { in: ['Yes', 'No'] }

  private

  def set_possession_to_yes
    self.possession = 'Yes'
  end

end
