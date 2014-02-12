class Tenant < BaseClass

  attr_accessor :title
  validates :title, presence: true, length: { maximum: 8 }
  attr_accessor :full_name
  attr_accessor :street
  attr_accessor :town
  attr_accessor :postcode

  def as_json
    pcode = UKPostcode.new(postcode)
    {
      "address" => "#{title} #{full_name}\n#{street}\n#{town}",
      "postcode1" => "#{pcode.outcode}",
      "postcode2" => "#{pcode.incode}"
    }
  end
end
