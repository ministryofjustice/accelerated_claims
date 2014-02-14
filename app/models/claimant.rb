class Claimant < BaseClass

  attr_accessor :company
  validates :company, presence: true

  attr_accessor :street
  validates :street, length: { maximum: 40 }

  attr_accessor :town
  attr_accessor :postcode

  def as_json
    postcode1, postcode2 = split_postcode
    {
      "address" => "#{company}\n#{street}\n#{town}",
      "postcode1" => "#{postcode1}",
      "postcode2" => "#{postcode2}"
    }
  end
end
