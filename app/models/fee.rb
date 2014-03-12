class Fee < BaseClass

  attr_accessor :court_fee
  validates :court_fee, presence: { message: 'must be entered' }
end
