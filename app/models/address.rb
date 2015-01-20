class Address < BaseClass

  attr_reader    :england_and_wales_only, :must_be_blank
  attr_writer    :postcode
  attr_accessor  :street, :absence_validation_message, :use_live_postcode_lookup, :manually_entered_address

  # Instantiate an Address object
  #
  def initialize(parent)
    @parent                 = parent
    @england_and_wales_only = false
    @must_be_blank          = false
    @suppress_validation    = false
  end

  def postcode
    if @postcode.present?
      pc = UKPostcode.new(@postcode)
      if pc.valid?
        return pc.norm
      end
    end
    @postcode
  end

  # forces validation of postcode to England and Wales only
  def england_and_wales_only!
    @england_and_wales_only = true
  end

  # forces validation of address to be blank
  def must_be_blank!
    @must_be_blank = true
  end

  def blank?
    @street.blank? && @postcode.blank?
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
    results << validate_postcode_in_england_or_wales if @england_and_wales_only
    results << validate_presence unless @must_be_blank
    results << validate_absence if @must_be_blank
    results << validate_maximum_number_of_newlines
    results << validate_street_length
    valid = results.include?(false) ? false : true
    transfer_error_messages_to_parent unless valid
    valid
  end

  def ==(other)
    other.street == @street && other.postcode == postcode
  end

  def validate_street_length
    if manually_entered_address == "1" && street.length > 140
      add_to_errors 'street', "#{possessive_subject_description.capitalize} address is too long (maximum 70 characters)"
      return false
    end
    true
  end

  def validate_maximum_number_of_newlines
    result = true
    unless street.nil?
      if @street.strip.count("\n") > 3
        add_to_errors 'street', "#{possessive_subject_description.capitalize} address can’t be longer than 4 lines"
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
      add_to_errors 'street', "Enter #{possessive_subject_description} full address"
      return false
    end
    return true
  end

  def validate_absence
    if @street.present?
      add_to_errors 'street', validate_absence_error_message('full address')
    end
    if @postcode.present?
      add_to_errors 'postcode', validate_absence_error_message('postcode')
    end
    return errors.empty?
  end

  def validate_absence_error_message(attribute)
    if absence_validation_message
      absence_validation_message.sub('%%attribute%%', attribute).capitalize
    else
      "#{attribute} for #{subject_description} must be blank".capitalize
    end
  end

  def validate_postcode_in_england_or_wales
    if postcode_blank_or_invalid?
      add_to_errors 'postcode', "Please enter a valid postcode for a property in England and Wales"
      return false
    end

    if postcode.present?
      plp = PostcodeLookupProxy.new(postcode, ['England', 'Wales'], @use_live_postcode_lookup)
      plp.lookup
      @postcode = plp.norm

      case plp.result_set['code']
      when 2000, 4040, 4220, 5030
        return true
      when 4041
        add_to_errors 'postcode', "Postcode is in #{plp.result_set['message']}. You can only use this service to regain possession of properties in England and Wales."
        return false
      else
        raise "Unexpected return from postcode lookup: #{plp.result_set.inspect}"
      end
    end
  end

  private

  def add_to_errors(as, message)
    errors[as] << message
  end

  def postcode_blank_or_invalid?
    postcode.blank? || UKPostcode.new(postcode).valid? == false
  end

  def transfer_error_messages_to_parent
    [:street, :postcode].each do |field|
      errors[field].each do |msg|
        @parent.errors[field] = msg
      end
    end
  end

end
