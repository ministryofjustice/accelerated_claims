class Fee < BaseClass

  attr_accessor :court_fee
  attr_accessor :account

  validates :court_fee, presence: { message: 'must be entered' }, length: { maximum: 8 }
  validates :account, format: { with: /\A[0-9]+/, message: 'Your fee account number should contain numbers only' }, length: { maximum: 10, message: 'Fee account number should only have 10 digits'}, allow_blank: true


  def court_fee
    "280.00"
  end

  def account
    if @account =~ /^[0-9]+$/ || @account.is_a?(Numeric)
      @account.to_s.rjust(10, '0')
    else
      @account
    end
  end
end
