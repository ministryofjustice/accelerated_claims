class Fee < BaseClass

  attr_accessor :court_fee
  validates :court_fee, presence: { message: 'must be entered' }

  def court_fee
    "175.00"
  end

end
