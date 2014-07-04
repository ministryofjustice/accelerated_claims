require 'valid_email'

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

  validates :email, email: {message: "address is not valid"}
  validates :phone, length: { maximum: 40 }
  validates :fax, length: { maximum: 40 }
  validates :dx_number, length: { maximum: 40 }

  def as_json
    postcode1, postcode2 = split_postcode
    {
      "address" => address_format,
      "postcode1" => postcode1.to_s,
      "postcode2" => postcode2.to_s,
      "email" => email.to_s,
      "phone" => phone.to_s,
      "fax" => fax.to_s,
      "dx_number" => dx_number.to_s
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
