

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

  validate :num_defendants_is_valid
  validates_with ContactValidator

  
  def num_defendants_is_valid
    if validate_presence?
      unless %w{ yes no }.include?(inhabits_property)
        errors[:inhabits_property] << "Please select whether or not #{subject_description} lives in the property"
      end
    elsif validate_absence?
      unless inhabits_property.nil?
        errors[:inhabits_property] << "Please select whether or not #{subject_description} lives in the property"
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

  def validate_presence?
    self.validate_presence == true
  end

  def validate_absence?
    self.validate_absence == true
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



  def subject_description
    if @num_claimants == 1
      "the defendant"
    else 
      if defendant_num == :defendant_one
        "defendant 1"
      else
        "defendant 2"
      end
    end
  end

end
