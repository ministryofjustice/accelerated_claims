class Defendant < BaseClass

  include Address

  # @do_partial_address_completion_validation = true

  attr_accessor :validate_presence, :validate_absence

  attr_accessor :title
  attr_accessor :full_name
  attr_accessor :street
  attr_accessor :postcode
  attr_accessor :property_address
  attr_accessor :inhabits_property
  attr_accessor :defendant_num

  validates :title, length: { maximum: 8 }
  validates :full_name, length: { maximum: 40 }

  validate :inhabits_property_is_valid
  validate :validate_defendant_state

  def inhabits_property_is_valid
    if validate_presence?
      unless %w{ yes no }.include?(inhabits_property.try(:downcase))
        errors[:inhabits_property] << "Please select whether or not #{subject_description} lives in the property"
      end
    elsif validate_absence?
      unless inhabits_property.blank?
        errors[:inhabits_property] << "Please select whether or not #{subject_description} lives in the property"
      end
    end

  end

  # main validation for claimant state
  def validate_defendant_state
    if validate_absence?
      validate_are_blank(:title, :full_name, :street, :postcode)
    elsif validate_presence?
      validate_fields_are_present
    end
  end

  def initialize(params = {})
    super
    unless params.include?(:validate_presence)
      @validate_presence = true unless params[:validate_absence] == true
    end
  end

  def validate_presence?
    self.validate_presence == true
  end

  def validate_absence?
    self.validate_absence == true
  end

  def empty?
    title.blank? && full_name.blank? && street.blank? && postcode.blank?
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
      "defendant #{@defendant_num}"
    end
  end


  def numbered_defendant_header
    "Defendant #{defendant_num}:\n"
  end


  def indented_details(spaces_to_indent)
    postcode1, postcode2 = split_postcode
    indentation = ' ' * spaces_to_indent
    str  = "#{indentation}#{title} #{full_name}\n"
    address_lines = street.split("\n")
    address_lines.each { |al| str += "#{indentation}#{al}\n" }
    str += "#{indentation}#{postcode1} #{postcode2}\n"
    str
  end

  

  private

  def display_name(field_name)
    case field_name
    when :street
      "full address"
    when :organization_name
      "company name or local authority name"
    else
      field_name.to_s.gsub('_', ' ')
    end
  end

  def validate_are_blank(*fields)
    fields.each do |field|
      errors.add(field, "must not be entered if number of defendants is 1") unless self.send(field).blank?
    end
  end

  def validate_fields_are_present
    if self.inhabits_property == 'yes'
      validate_are_present(:title, :full_name)
    else
      validate_are_present(:title, :full_name, :street, :postcode)
    end
  end

  def validate_are_present(*fields)
    fields.each do |field|
      errors.add(field, "Enter #{subject_description}'s #{display_name(field)}") if self.send(field).blank?
    end
  end

end
