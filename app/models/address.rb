class Address < BaseClass

 attr_reader    :england_and_wales_only, :must_be_blank
 attr_accessor  :postcode, :street


  # instantiate a new address from the given params using the options
  # valid options are:
  #  - england_wales: true if address is to be limited to England and Wales.  Default is false
  #  - subject: the name of the subject to be included in 
  #
  def initialize(parent)
    @parent                 = parent
    @street                 = @parent.params[:street]
    @postcode               = @parent.params[:postcode]
    @england_and_wales_only = false
    @must_be_blank          = determine_blankness
    @suppress_validation    = false
  end

  # forces validation of postcode to England and Wales only
  def england_and_wales_only!
    @england_and_wales_only = true
  end

  # forces validation of address to be blank
  def must_be_blank!
    @must_be_blank = true
  end

  def subject_description
    @parent.respond_to?(:subject_description) ? @parent.subject_description : @parent.class.to_s
  end

  def possessive_subject_description
    @parent.respond_to?(:possessive_subject_description) ? @parent.possessive_subject_description : "#{@parent.class.to_s}'s"
  end

  def suppress_validation!
    errors.clear
    @suppress_validation = true
  end

  def valid?
    return true if @suppress_validation
    results = []
    results << validate_postcode if @england_and_wales_only == true
    results << validate_presence if @must_be_blank == false
    results << validate_absence if @must_be_blank == true
    results << validate_maximum_street_length
    results << validate_maximum_number_of_newlines
    result = results.include?(false) ? false : true
    transfer_error_messages_to_parent if result == false
    result
  end

  def ==(other)
    other.street == @street && other.postcode == @postcode
  end

  def validate_maximum_street_length
    if !@street.nil? && @street.length > 70
      errors[:street] << "#{possessive_subject_description.capitalize} address is too long (maximum 70 characters)"
      return false
    end
    return true
  end


  def validate_maximum_number_of_newlines
    result = true
    unless street.nil?
      if @street.strip.count("\n") > 3
        errors.add(:street, "#{possessive_subject_description.capitalize} address can’t be longer than 4 lines")
        result = false
      end
    end
    result
  end

  def indented_details(spaces_to_indent)
    postcode1, postcode2 = split_postcode
    indentation = ' ' * spaces_to_indent
    str  = "#{indentation}#{@parent.title} #{@parent.full_name}\n"
    address_lines = street.split("\n")
    address_lines.each { |al| str += "#{indentation}#{al}\n" }
    str += "#{indentation}#{postcode1} #{postcode2}\n"
    str
  end

  def validate_presence
    if @street.blank?
      errors['street'] << "Enter #{possessive_subject_description} full address"
      return false
    end
    return true
  end

  def validate_absence
    if @street.present?
      errors[:street] << "Address for #{subject_description} must be blank"
    end
    if @postcode.present?
      errors[:postcode] << "Postcode for #{subject_description} must be blank"
    end
    return errors.empty?
  end

  def validate_postcode
    if postcode.blank? || UKPostcode.new(postcode).valid? == false
      errors['postcode'] << "Please enter a valid postcode for a property in England and Wales"
      return false
    end

    if postcode.present?
      plp = PostcodeLookupProxy.new(postcode, ['England', 'Wales'], @livepc)
      plp.lookup
      @postcode = plp.norm

      case plp.result_set['code']
      when 2000
        return true
      when 4040
        return true
      when 4041
        errors['postcode'] << "Postcode is in #{plp.result_set['message']}. You can only use this service to regain possession of properties in England and Wales."
        return false
      when 4220
        return true
      when 5030
        return true
      else
        raise "Unexpected return from postcode lookup: #{plp.result_set.inspect}"
      end
    end
  end

  private 

  def determine_blankness
    if @parent.params['validate_absence'] == true || @parent.params['address_same_as_first_claimant'] == 'Yes'
      true
    else
      false
    end
  end
  

  def transfer_error_messages_to_parent
    [:street, :postcode].each do |field|
      errors[field].each do |msg|
        @parent.errors[field] = msg
      end
    end
  end


end