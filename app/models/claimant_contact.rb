class ClaimantContact < BaseClass

  include Address

  attr_accessor :title
  attr_accessor :full_name
  attr_accessor :company_name

  attr_accessor :email
  attr_accessor :phone
  attr_accessor :fax
  attr_accessor :dx_number
  attr_accessor :reference_number

  attr_accessor :legal_costs

  validates :title, length: { maximum: 8 }
  validates :company_name, length: { maximum: 60 }
  validates :full_name, length: { maximum: 40 }
  validates :legal_costs, format: { with: /\A\d+(\.\d{2})?\z/, message: 'must be a valid amount' }, allow_blank: true

  def as_json
    postcode1, postcode2 = split_postcode
    {
      "address" => "#{address_format}",
      "postcode1" => "#{postcode1}",
      "postcode2" => "#{postcode2}",
      "email" => "#{email}",
      "phone" => "#{phone}",
      "fax" => "#{fax}",
      "dx_number" => "#{dx_number}",
      "reference_number" => "#{reference_number}",
      "legal_costs" => "#{legal_costs}"
    }
  end

  private
  def address_format
    short_format = "#{title} #{full_name}\n#{street}\n#{town}"
    long_format = "#{title} #{full_name}\n#{company_name}\n#{street}\n#{town}"
    company_name.blank? ? short_format : long_format
  end
end
