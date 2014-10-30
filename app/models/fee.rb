class Fee < BaseClass

  attr_accessor :court_fee
  attr_accessor :fee_account

  validates :court_fee, presence: { message: 'must be entered' }, length: { maximum: 8 }
  validates :fee_account, length: { is: 10 }, allow_blank: true

  before_validation :zero_pad_fee_account

  def court_fee
    "280.00"
  end

  private

  def zero_pad_fee_account
    self.fee_account = self.fee_account.to_s.rjust(10, '0') unless self.fee_account.blank?
  end
end
