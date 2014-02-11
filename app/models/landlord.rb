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
      "claimant" => "#{company}\n#{street}\n#{town}",
      "claimant_postcode1" => "#{pcode.outcode}",
      "claimant_postcode2" => "#{pcode.incode}"
    }
  end
end
