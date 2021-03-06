require 'email_validator'

class ClaimantContact < BaseClass

  attr_accessor :title
  attr_accessor :full_name
  attr_accessor :company_name
  attr_accessor :address

  attr_accessor :email
  attr_accessor :phone
  attr_accessor :fax
  attr_accessor :dx_number

  delegate :street, :street=, :postcode, :postcode=, :indented_details, :manually_entered_address, :manually_entered_address=, to: :address

  validates :title, length: { maximum: 8 }
  validates :company_name, length: { maximum: 40 }
  validates :full_name, length: { maximum: 40 }
  validates :email, email: true, if: ->(f) { f.email.present? }
  validates :phone, format: { with: /[0-9\s]{9,15}/,  message: "Enter a valid claimant telephone number", allow_blank: true }
  validates :fax, length: { maximum: 40 }
  validates :dx_number, length: { maximum: 40 }

  validate  :name_and_address_consistency

  def initialize(params = {})
    @address = Address.new(self)
    super

    @address.absence_validation_message= 'Claimant contact %%attribute%% must be blank if no full name or company name is specified'
  end

  def name_and_address_consistency
    # if either title and name or company or both is present, then address must be present
    # if address present, then either title and name or company or both must be present

    if title.blank? && full_name.blank? && company_name.blank?
      @address.must_be_blank!
    end
    @address.valid?
  end

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

  def subject_description
    "the claimant contact"
  end

  def possessive_subject_description
    "#{subject_description}'s"
  end

  private

  def all_blank?(*fields)
    result = true
    fields.each do | field |
      if send(field).present?
        result = false
        break
      end
    end
  end

  def address_format
    if company_name.blank?
      "#{title} #{full_name}\n#{street}"
    else
      "#{title} #{full_name}\n#{company_name}\n#{street}"
    end
  end
end
