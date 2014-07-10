

class Defendant < BaseClass

  @do_partial_address_completion_validation = true

  attr_accessor :validate_presence, :validate_absence

  attr_accessor :title
  attr_accessor :full_name
  attr_accessor :street
  attr_accessor :postcode
  attr_accessor :property_address
  attr_accessor :inhabits_property
  attr_accessor :num_defendants
  attr_accessor :defendant_num

  validates :title, length: { maximum: 8 }
  validates :full_name, length: { maximum: 40 }
  validate :inhabits_property_has_been_set
  
  validates_with ContactValidator

  def inhabits_property_has_been_set
    if validate_presence == true
      unless %w{ yes no }.include?(inhabits_property)
        errors[:inhabits_property] << inhabits_property_missing_message
      end
    end
  end


  def initialize(params = {})
    super
    unless params.include?(:validate_presence)
      @validate_presence = true unless params[:validate_absence] == true
    end
    @num_defendants = @num_defendants.nil? ? 1 : @num_defendants.to_i
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

  def title_missing_message
    "Enter #{subject_description} title"
  end


  def full_name_missing_message
    "Enter #{subject_description} full name"
  end

  def full_address_missing_message
    "Enter #{subject_description} full address"
  end

  def postcode_missing_message
    "Enter #{subject_description} postcode"
  end

  def inhabits_property_missing_message
    "You must say whether #{subject_description} lives in the property"
  end





  def subject_description
    if @num_claimants == 1
      "the defendant's"
    else 
      if defendant_num == :defendant_one
        "defendant 1's"
      else
        "defencant 2's"
      end
    end
  end

end
