require 'uk_postcode'

class Property < BaseClass

  include Address
  validate :address_is_present_and_correct

  attr_accessor :house
  validates :house, presence: { message: 'Please select what kind of property it is' }, inclusion: { in: ['Yes', 'No'] }


  def address_is_present_and_correct
    if street.blank? && postcode.blank?
      errors[:postcode_picker] << "Enter a postcode and select an address or manually enter the address"
    else
      errors[:street] << 'Enter the full address' if street.blank?
      errors[:postcode] << 'Enter the postcode' if postcode.blank?
    end
  end

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

  def postcode_picker_error?
    errors[:postcode_picker].any?
  end

end
