class Claimant < BaseClass

  include ActiveModel::Validations
  include Comparable

  attr_accessor :validate_presence, :validate_absence, :address
  attr_accessor :claimant_num
  attr_accessor :title
  attr_accessor :full_name
  attr_accessor :organization_name
  attr_accessor :claimant_type
  attr_accessor :address_same_as_first_claimant
  attr_reader   :params

  delegate :street, :street=, :postcode, :postcode=, to: :address


  validate :validate_claimant_state

  validates :claimant_num, presence: { message: 'Claimant number not specified' }, allow_nil: false
  validates :title, length: { maximum: 8 }
  validates :full_name, length: { maximum: 40 }

  def initialize(params = {})
    @params = params
    @address = Address.new(self)
    unless params.include?(:validate_presence)
      @validate_presence = true unless params[:validate_absence] == true
    end
    
    @address.must_be_blank! if @validate_absence == true

    @check_address_same_as_first_claimant = params['validate_address_same_as_first_claimant']
    @claimant_type = params['claimant_type']
    super
  end

  def ==(other)
    return false if instance_variables.size != other.instance_variables.size
    instance_variables.each do |ivar|
      return false unless instance_variable_get(ivar) == other.instance_variable_get(ivar)
    end
  end

  def empty?
    title.blank? && full_name.blank? && organization_name.blank? && street.blank? && postcode.blank?
  end

  def valid?
    @address.valid?
  end

  # main validation for claimant state
  def validate_claimant_state
    if validate_absence?
      validate_are_blank(:title, :full_name, :organization_name, :street, :postcode)
    else
      validate_fields_are_present
    end
  end

  def validate_absence?
    validate_absence == true
  end

  def validate_presence?
    validate_presence == true
  end

  def as_json
    postcode1, postcode2 = split_postcode
    address = @claimant_type == 'organization' ? "#{organization_name}\n#{street}" : "#{title} #{full_name}\n#{street}"
    {
      "address" => address,
      "postcode1" => "#{postcode1}",
      "postcode2" => "#{postcode2}"
    }
  end

  def first_claimant?
    @claimant_num == 1
  end

  def subject_description
    if @num_claimants == 1
      "the claimant"
    else
      "claimant #{@claimant_num}"
    end
  end

  def possessive_subject_description
    "#{subject_description}'s"
  end

  def numbered_header
    "Claimant #{claimant_num}:\n"
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
      unless self.send(field).blank?
        errors.add(field, "must not be entered if number of claimants is 1") unless self.send(field).blank?
      end
    end
  end

  def validate_fields_are_present
    case @claimant_type
    when 'organization'
      validate_organisation_fields_are_present
    when 'individual'
      validate_individual_fields_are_present
    else
      errors.add(:claimant_type, 'Please select what kind of claimant you are')
    end
  end

  def validate_address_same_as_first_claimant
    if @check_address_same_as_first_claimant && address_same_as_first_claimant.blank? && !first_claimant?
      errors.add(:address_same_as_first_claimant, "You must specify whether #{subject_description}'s address is the same as the first claimant")
    end
  end

  def validate_organisation_fields_are_present
    validate_are_present(:organization_name)
    validate_address
  end

  def validate_individual_fields_are_present
    validate_are_present(:title, :full_name)
    validate_address
  end

  def validate_address
    validate_address_same_as_first_claimant
    if check_address_fields?
      errors[:street] << "Enter #{possessive_subject_description} full address" if street.blank?
    end
  end

  def validate_are_present(*fields)
    fields.each do |field|
      errors.add(field, "Enter #{subject_description}'s #{display_name(field)}") if self.send(field).blank?
    end
  end

  def check_address_fields?
    check = (address_same_as_first_claimant != 'Yes') && errors[:address_same_as_first_claimant].empty?
    check
  end

end

