class Fee < BaseClass

  attr_accessor :court_fee
  validates :court_fee, presence: { message: 'must be entered' }, length: { maximum: 8 }

  def court_fee
    "280.00"
  end

end
