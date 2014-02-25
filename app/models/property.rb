require 'uk_postcode'

class Property < BaseClass

  attr_accessor :street
  validates :street, presence: { message: 'must be entered' }, length: { maximum: 70 }

  attr_accessor :town
  validates :town, length: { maximum: 40 }

  attr_accessor :postcode
  validates :postcode, presence: { message: 'must be entered' }, length: { maximum: 8 }
  validate :full_postcode

  def full_postcode
    errors.add(:postcode, "not full postcode") unless !postcode.nil? && UKPostcode.new(postcode).full?
  end

  attr_accessor :house
  validates :house, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }

  def as_json
    postcode1, postcode2 = split_postcode
    {
      "address" => "#{street}\n#{town}",
      "postcode1" => "#{postcode1}",
      "postcode2" => "#{postcode2}",
      "house" => house
    }
  end

end
