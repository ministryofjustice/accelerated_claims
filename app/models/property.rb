require 'uk_postcode'

class Property < BaseClass

  include Address

  attr_accessor :house
  attr_reader   :livepc

  validates :house, presence: { message: 'Please select what kind of property it is' }, inclusion: { in: ['Yes', 'No'] }

  validates :street, presence: { message: 'Enter the property address' }
  validates :postcode, presence: { message: 'Enter the property postcode' }
  validate  :postcode_is_in_england_or_wales 


  def initialize(params)
    @livepc = params['livepc'] || false
    puts "++++++ DEBUG PORPERTY LIVEPC IS #{@livepc} ++++++ #{__FILE__}::#{__LINE__} ++++\n"
    
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
    puts "++++++ DEBUG postcode_is_in_england_or_wales ++++++ #{__FILE__}::#{__LINE__} ++++\n"
    
    if postcode.present?
      puts "++++++ DEBUG present ++++++ #{__FILE__}::#{__LINE__} ++++\n"
      
      plp = PostcodeLookupProxy.new(postcode, ['England', 'Wales'], @livepc)
      plp.lookup

      puts "++++++ DEBUG plp.result_set #{plp.result_set} ++++++ #{__FILE__}::#{__LINE__} ++++\n"
      

      case plp.result_set['code']
      when 2000
        true
      when 4040
        errors['postcode'] << "No address found. Please enter the address manually"
        false
      when 4041
        errors['postcode'] << "Postcode is in #{plp.result_set['message']}. You can only use this service to regain possession of properties in England and Wales."
        false
      when 4220
        errors['postcode'] << "Please enter a valid postcode in England and Wales"
        false
      when 5030
        true
      else
        raise "Unexpected return from postcode lookup: #{plp.result_set.inspect}"
      end
    end
  end

end
