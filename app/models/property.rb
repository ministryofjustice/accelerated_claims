require 'uk_postcode'

class PropertyError

  def self.full_address_error
    'Enter the full address'
  end

  def self.postcode_error
    'Enter the postcode'
  end
end


class Property < BaseClass

  include Address

  validates :street, presence: { message: PropertyError.full_address_error }
  validates :postcode, presence: { message: 'Enter the postcode' }

  attr_accessor :house
  validates :house, presence: { message: 'Please select what kind of property it is' }, inclusion: { in: ['Yes', 'No'] }

  attr_accessor :room_number

  def as_json
    postcode1, postcode2 = split_postcode
    {
      "address" => "#{street}",
      "postcode1" => "#{postcode1}",
      "postcode2" => "#{postcode2}",
      "house" => house
    }
  end
end
