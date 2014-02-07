require 'uk_postcode'

class Property < BaseClass

  attr_accessor :street
  validates :street, presence: true, length: { maximum: 70 }

  attr_accessor :town
  validates :town, length: { maximum: 40 }

  attr_accessor :postcode
  validates :postcode, presence: true, length: { maximum: 8 }
  validate :full_postcode

  def full_postcode
    errors.add(:full_postcode, "not full postcode") unless UKPostcode.new(postcode).full?
  end

  attr_accessor :house
  validates :house, presence: true

  def as_json
    pcode = UKPostcode.new(postcode)
    { "property" => "#{street}, #{town}", "property_postcode1" => "#{pcode.outcode}", "property_postcode2" => "#{pcode.incode}" }
  end

end
