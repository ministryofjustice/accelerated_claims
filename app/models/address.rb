class Address < BaseClass

 validates :street, presence: { message: 'Enter the property address' }

 attr_reader :street, :postcode, :england_and_wales_only, :must_be_blank


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
    @must_be_blank          = false
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


  def valid?
    results = []
    results << validate_postcode if @england_and_wales_only == true
    results << validate_presence if @must_be_blank == false
    results << validate_absence if @must_be_blank == true
    results.include?(false) ? false : true
  end


  def validate_presence
    if @street.blank?
      errors['street'] << "Enter the #{subject_description} address"
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


end