class ContactValidator < ActiveModel::Validator


  def validate(record)
    validate_is_present(record) if record.validate_presence == true
    validate_is_absent(record) if record.validate_absence == true
  end


  private

  def validate_is_present(record)
    record.errors[:title] << title_missing_message(record) if record.is_a?(Defendant) && record.title.blank?
    record.errors[:title] << title_missing_message(record) if is_individual_claimant?(record) && record.title.blank?
    record.errors[:organization_name] << "You must enter a company name or local authority name" if is_organization_claimant?(record) && record.organization_name.blank?

    if record.full_name.blank?
      record.errors[:full_name] << full_name_missing_message(record) unless is_organization_claimant?(record)
    end
    validate_address(record) if record.is_a?(Claimant)
    if record.is_a?(Defendant) && record.inhabits_property == 'no'
      validate_address(record) if inhabits_property_has_been_set(record)
    end
  end


  def validate_address(record)
    record.errors[:street]    << full_address_missing_message(record) if record.street.blank?
    record.errors[:postcode]  << postcode_missing_message(record)  if record.postcode.blank?
  end


  def validate_is_absent(record)
    fields = record.is_a?(Defendant) ? [:title, :full_name, :street, :postcode] : [:full_name, :street, :postcode]
    fields.each do |field|
      record.errors[field] << "must not be entered if number of claimants is 1 BBBBB" if record.send(field).present?
    end
  end


  def title_missing_message(record)
    "Enter #{record.subject_description}'s title"
  end

  def full_name_missing_message(record) 
    "Enter #{record.subject_description}'s full name"
  end

  def full_address_missing_message(record) 
    "Enter #{record.subject_description}'s full address"
  end

  def postcode_missing_message(record) 
    "Enter #{record.subject_description}'s postcode"
  end


  def inhabits_property_missing_message
    "You must say whether #{record.subject_description} lives in the property"
  end

  def is_individual_claimant?(record)
    record.is_a?(Claimant)  && record.claimant_type == 'individual'
  end

  def is_organization_claimant?(record)
    record.is_a?(Claimant)  && record.claimant_type == 'organization'
  end    



  def inhabits_property_has_been_set(record)
    result = true
    if record.validate_presence == true
      unless %w{ yes no }.include?(record.inhabits_property)
        record.errors[:inhabits_property] << inhabits_property_missing_message
        result = false
      end
    end
    result
  end
end
