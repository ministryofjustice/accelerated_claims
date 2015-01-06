class Defendant < BaseClass

  include SharedPartyMethods

  attr_accessor :validate_presence, :validate_absence

  attr_accessor :title
  attr_accessor :full_name
  attr_accessor :address
  attr_accessor :inhabits_property
  attr_accessor :defendant_num
  attr_reader   :params

  delegate :street, :street=, :postcode, :postcode=, :indented_details, to: :address

  validates :title, length: { maximum: 8 }
  validates :full_name, length: { maximum: 40 }

  validate :inhabits_property_is_valid
  validate :validate_defendant_state
  validate :address_validation

  def initialize(params = {})
    @address = Address.new(self)
    super

    unless params.include?(:validate_presence)
      @validate_presence = true unless validate_absence?
    end

    if validate_absence?
      @address.must_be_blank!
    end

    if validate_presence?
      @inhabits_property = @address.blank? ? 'yes' : 'no'
    end

    @address.suppress_validation! if @inhabits_property != 'no'
  end

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

  def address_validation
    @address.valid?
  end

  def validate_presence?
    @validate_presence == true
  end

  def validate_absence?
    @validate_absence == true
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

  def possessive_subject_description
    "#{subject_description}'s"
  end

  def numbered_header
    "Defendant #{defendant_num} name and address for service:\n"
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
    validate_are_present(:full_name)
  end
end

