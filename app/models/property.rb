require 'uk_postcode'

class Property < BaseClass

  include Address

  validates :street, presence: { message: 'must be entered' }
  validates :postcode, presence: { message: 'must be entered' }

  attr_accessor :house
  validates :house, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'no'] }

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
