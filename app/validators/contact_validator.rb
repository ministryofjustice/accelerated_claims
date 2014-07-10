class ContactValidator < ActiveModel::Validator


  def validate(record)
    validate_is_present(record) if record.validate_presence == true
    validate_is_absent(record) if record.validate_absence == true
  end


  private

  def validate_is_present(record)
    record.errors[:title] << record.title_missing_message if record.is_a?(Defendant) && record.title.blank?

    if record.full_name.blank?
      record.errors[:full_name] << record.full_name_missing_message
    end

    unless record.is_a?(Defendant) && record.inhabits_property == 'yes'
      record.errors[:street]    << record.full_address_missing_message if record.street.blank?
      record.errors[:postcode]  << record.postcode_missing_message if record.street.blank?
    end
  end


  def validate_is_absent(record)
    fields = record.is_a?(Defendant) ? [:title, :full_name, :street, :postcode] : [:full_name, :street, :postcode]
    fields.each do |field|
      record.errors[field] << "must not be entered if number of claimants is 1" if record.send(field).present?
    end
  end





end