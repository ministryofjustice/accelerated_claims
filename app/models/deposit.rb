class Deposit < BaseClass

  attr_accessor :received
  validates :received, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }

  attr_accessor :information_given_date

  attr_accessor :ref_number
  validates :ref_number, length: { maximum: 20 }

  attr_accessor :as_property
  validates :as_property, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }

  attr_accessor :as_money
  validates :as_money, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }
  
  validate :money_or_property_must_be_selected_if_received


  validates_with DateValidator, :fields => [:information_given_date]

  with_options if: -> deposit { deposit.received == 'No'} do |deposit|
    err = 'can\'t be provided if there is no deposit given'
    deposit.validates :information_given_date, absence: { message: err }
    deposit.validates :ref_number, absence: { message: err }
  end

  with_options if: -> deposit { deposit.received == 'Yes' && deposit.as_money == 'Yes'} do |deposit|
    deposit.validates :ref_number, presence: true
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
        errors[:as_money] = "or As Property must be selected as the type of deposit"
      end
    end
  end
end
