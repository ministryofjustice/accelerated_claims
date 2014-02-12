class Landlord < BaseClass

  attr_accessor :company
  validates :company, presence: true

  attr_accessor :street
  validates :street, length: { maximum: 40 }

  attr_accessor :town
  attr_accessor :postcode

  def as_json
    pcode = UKPostcode.new(postcode)
    {
      "address" => "#{company}\n#{street}\n#{town}",
      "postcode1" => "#{pcode.outcode}",
      "postcode2" => "#{pcode.incode}"
    }
  end
end
