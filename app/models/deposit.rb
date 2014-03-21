class Deposit < BaseClass

  attr_accessor :received
  attr_accessor :information_given_date
  attr_accessor :ref_number
  attr_accessor :as_property

  validate do |deposit|
    deposit.errors.add(:received, "Deposit received must be answered") unless %w(Yes No).include?(deposit.received)
    deposit.errors.add(:as_property, "Deposit received in the form of property must be answered") unless %w(Yes No).include?(deposit.as_property)
  end

  def as_json
    json = super
    json = split_date :information_given_date, json
    json
  end
end
