class ClaimantContact < BaseClass

  @do_partial_address_completion_validation = true
  include Address

  attr_accessor :title
  attr_accessor :full_name
  attr_accessor :company_name

  attr_accessor :email
  attr_accessor :phone
  attr_accessor :fax
  attr_accessor :dx_number

  validates :title, length: { maximum: 8 }
  validates :company_name, length: { maximum: 40 }
  validates :full_name, length: { maximum: 40 }

  validates :email, length: { maximum: 40 }
  validates :phone, length: { maximum: 40 }
  validates :fax, length: { maximum: 40 }
  validates :dx_number, length: { maximum: 40 }

  def as_json
    postcode1, postcode2 = split_postcode
    {
      "address" => "#{address_format}",
      "postcode1" => "#{postcode1}",
      "postcode2" => "#{postcode2}",
      "email" => "#{email}",
      "phone" => "#{phone}",
      "fax" => "#{fax}",
      "dx_number" => "#{dx_number}"
    }
  end

  private
  def address_format
    if company_name.blank?
      "#{title} #{full_name}\n#{street}"
    else
      "#{title} #{full_name}\n#{company_name}\n#{street}"
    end
  end
end
