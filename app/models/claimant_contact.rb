class ClaimantContact < BaseClass

  attr_accessor :title
  attr_accessor :full_name

  attr_accessor :street
  attr_accessor :town
  attr_accessor :postcode

  attr_accessor :email
  attr_accessor :phone
  attr_accessor :fax
  attr_accessor :dx_number
  attr_accessor :reference_number

  validates :title, length: { maximum: 8 }
  validates :full_name, length: { maximum: 40 }
  validates :street, length: { maximum: 40 }
  validates :postcode, length: { maximum: 8 }

  def as_json
    postcode1, postcode2 = split_postcode
    {
      "address" => "#{title} #{full_name}\n#{street}\n#{town}",
      "postcode1" => "#{postcode1}",
      "postcode2" => "#{postcode2}",
      "email" => "#{email}",
      "phone" => "#{phone}",
      "fax" => "#{fax}",
      "dx_number" => "#{dx_number}",
      "reference_number" => "#{reference_number}"
    }
  end
end
