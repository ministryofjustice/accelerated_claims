require 'uk_postcode'

class Property < BaseClass

  attr_accessor   :house, :address
  attr_reader     :livepc, :params

  delegate :street, :street=, :postcode, :postcode=, to: :address

  validates :house, presence: { message: 'Please select what kind of property it is' }, inclusion: { in: ['Yes', 'No'] }
  validate :address_validation

  def initialize(params)
    @params = params
    @livepc = params['livepc'] || false
    @address = Address.new(self)
    @address.england_and_wales_only!
    super
  end

  def address_validation
    @address.valid?               # This takes care of transferring error messages from Address object to Property object
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
end
