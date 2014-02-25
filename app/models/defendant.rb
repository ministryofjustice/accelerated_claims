class Defendant < BaseClass

  attr_accessor :title
  validates :title, presence: true, length: { maximum: 8 }

  attr_accessor :full_name
  validates :full_name, presence: true, length: { maximum: 40 }

  attr_accessor :street
  attr_accessor :town
  attr_accessor :postcode

  def as_json
    postcode1, postcode2 = split_postcode
    {
      "address" => "#{title} #{full_name}\n#{street}\n#{town}",
      "postcode1" => postcode1,
      "postcode2" => postcode2
    }
  end
end
