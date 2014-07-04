class Defendant < BaseClass

  @do_partial_address_completion_validation = true

  attr_accessor :validate_presence, :validate_absence

  attr_accessor :title
  attr_accessor :full_name
  attr_accessor :street
  attr_accessor :postcode
  attr_accessor :property_address
  attr_accessor :inhabits_property

  validates :title, length: { maximum: 8 }
  validates :full_name, length: { maximum: 40 }

  with_options if: -> defendant { defendant.validate_presence == true} do |defendant|
    defendant.validates :inhabits_property, inclusion:  { in: ['yes', 'no'], message: "Question (Does the defendant live in the property?) must be answered"  }
  end
  
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
    if inhabits_property == 'no'
      (title.present? && full_name.present? && !address_blank?)
    else
      (title.present? && full_name.present?)
    end
  end


  def address_blank?
    (street.blank? && postcode.blank?)
  end
end
