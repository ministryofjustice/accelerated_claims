require 'uk_postcode'

class Property < BaseClass

  include Address

  attr_accessor :house
  validates :house, presence: { message: 'Please select what kind of property it is' }, inclusion: { in: ['Yes', 'No'] }

  validates :street, presence: { message: 'Enter the property address' }
  validates :postcode, presence: { message: 'Enter the property postcode' }





  def as_json
    postcode1, postcode2 = split_postcode
    {
      "address"   => "#{street}",
      "postcode1" => "#{postcode1}",
      "postcode2" => "#{postcode2}",
      "house"     => house
    }
  end

  def subject_description
    'property'
  end

  def possessive_subject_description
    subject_description
  end

end
