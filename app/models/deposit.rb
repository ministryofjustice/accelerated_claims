class Deposit < BaseClass

  attr_accessor :received
  validates :received, presence: { message: 'You must say whether the defendant paid a deposit' }, inclusion: { in: ['Yes', 'No'] }

  attr_accessor :information_given_date

  attr_accessor :ref_number
  validates :ref_number, length: { maximum: 20 }

  attr_accessor :as_property

  attr_accessor :as_money

  validate :money_or_property_must_be_selected_if_received

  with_options if: -> deposit { deposit.received == 'No'} do |deposit|
    deposit.validates :ref_number, absence: { message: 'You should not give a deposit scheme reference number if no deposit was given' }
    deposit.validates :information_given_date, absence: { message: 'You should not give an information given date if no deposit was given' }
  end

  with_options if: -> deposit { deposit.received == 'Yes' && deposit.as_money == 'Yes'} do |deposit|
    deposit.validates :ref_number, presence: { message: 'Enter the tenancy deposit scheme reference number' }
    deposit.validates :information_given_date, presence: { message: 'Enter the date you gave the defendant this information' }
  end

  with_options if: -> deposit { deposit.received == 'Yes' && deposit.as_money == 'No'} do |deposit|
    deposit.validates :ref_number, absence: { message: 'You should not give a deposit scheme reference number if the deposit was given as property' }
    deposit.validates :information_given_date, absence: { message: 'You should not give an information given date if the deposit was given as property' }
  end

  def as_json
    json = super
    json = split_date :information_given_date, json
    json
  end

  private

  def money_or_property_must_be_selected_if_received
    if received && received == 'Yes'
      if as_money == 'No' && as_property == 'No'
        errors[:as_money] << 'You must say what kind of deposit the defendant paid'
      end
    end
  end
end
