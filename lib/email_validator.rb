class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    parsed = Mail::Address.new(value)
    record.errors.add(attribute, "Enter a valid email address") unless parsed.address == value && parsed.local != value && domain_has_tld?(parsed)
  rescue Mail::Field::ParseError
    record.errors.add(attribute, "Enter a valid email address")
  end


  private
  
  def domain_has_tld?(address)
    (address.domain =~ /.+\..+/).nil? ? false : true
  end
end
