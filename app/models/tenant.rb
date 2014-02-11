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
      "defendant" => "#{title} #{full_name}\n#{street}\n#{town}",
      "defendant_postcode1" => "#{pcode.outcode}",
      "defendant_postcode2" => "#{pcode.incode}"
    }
  end
end
