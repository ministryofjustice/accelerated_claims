require 'uk_postcode'

class Property < BaseClass
  include Address

  attr_accessor :house
  attr_reader   :livepc

  validates :house, presence: { message: 'Please select what kind of property it is' }, inclusion: { in: ['Yes', 'No'] }
  validates :street, presence: { message: 'Enter the property address' }
  validate  :postcode_is_in_england_or_wales

  def initialize(params)
    @livepc = params['livepc'] || false
    super
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

  private

  def postcode_is_in_england_or_wales
    if postcode.blank? || UKPostcode.new(postcode).valid? == false
      errors['postcode'] << "Please enter a valid postcode for a property in England and Wales"
      return false
    end

    if postcode.present?
      plp = PostcodeLookupProxy.new(postcode, ['England', 'Wales'], @livepc)
      plp.lookup
      @postcode = plp.norm

      case plp.result_set['code']
      when 2000
        true
      when 4040
        true
      when 4041
        errors['postcode'] << "Postcode is in #{plp.result_set['message']}. You can only use this service to regain possession of properties in England and Wales."
        false
      when 4220
        true
      when 5030
        true
      else
        raise "Unexpected return from postcode lookup: #{plp.result_set.inspect}"
      end
    end
  end
end
