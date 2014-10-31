class Fee < BaseClass

  attr_accessor :court_fee
  attr_accessor :account

  validates :court_fee, presence: { message: 'must be entered' }, length: { maximum: 8 }
  validates :account, length: { is: 10 }, allow_blank: true


  def court_fee
    "280.00"
  end

  def account
    @account.blank? ? '' : @account.to_s.rjust(10, '0')
  end
end
