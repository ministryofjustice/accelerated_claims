class Defendant < BaseClass

  @do_partial_address_completion_validation = true
  include Address

  attr_accessor :validate_presence, :validate_absence

  attr_accessor :title
  attr_accessor :full_name
  attr_accessor :property_address

  validates :title, length: { maximum: 8 }
  validates :full_name, length: { maximum: 40 }

  validates_with ContactValidator
 

  def initialize(params = {})
    super
    unless params.include?(:validate_presence)
      @validate_presence = true unless params[:validate_absence] == true
    end
  end


  def as_json
    if present?
      postcode1, postcode2 = split_postcode
      {
        "address" => "#{title} #{full_name}\n#{street}",
        "postcode1" => postcode1,
        "postcode2" => postcode2
      }
    else
      {}
    end
  end

  def present?
    !(title.blank? && full_name.blank?)
  end
end
