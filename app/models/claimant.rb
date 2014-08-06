class Claimant < BaseClass


  include Address
  include ActiveModel::Validations

  attr_accessor :validate_presence, :validate_absence
  attr_accessor :num_claimants
  attr_accessor :claimant_num
  attr_accessor :title
  attr_accessor :full_name
  attr_accessor :organization_name  
  attr_accessor :claimant_type


  validate :validate_claimant_state

  validates :title, length: { maximum: 8 }
  validates :full_name, length: { maximum: 40 }




  def initialize(params = {})
    super
    unless params.include?(:validate_presence)
      @validate_presence = true unless params[:validate_absence] == true
    end
    @num_claimants = @num_claimants.nil? ? 1 : @num_claimants.to_i
  end
  


  # main validation for claimant state
  def validate_claimant_state
    if validate_absence?
      validate_are_blank(:title, :full_name, :organization_name, :claimant_type, :street, :postcode)
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



  def subject_description
    if @num_claimants == 1
      "the claimant"
    else
      if @claimant_num == :claimant_one
        "claimant 1"
      else
        "claimant 2"
      end
    end
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
      errors.add(field, "must not be entered if number of claimants is 1") unless self.send(field).blank?
    end
  end


  def validate_fields_are_present
    case claimant_type
    when 'organization'
      validate_organization_fields_are_present
    when 'individual'
      validate_individual_fields_are_present
    end
  end


  def validate_organization_fields_are_present
    validate_are_present(:organization_name, :street, :postcode)
  end


  def validate_individual_fields_are_present
    validate_are_present(:title, :full_name, :street, :postcode)
  end


  def validate_are_present(*fields)
    fields.each do |field|
      errors.add(field, "Enter #{subject_description}'s #{display_name(field)}") if self.send(field).blank?
    end
  end


end




























