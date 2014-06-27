class ContactValidator < ActiveModel::Validator


  def validate(record)
    validate_is_present(record) if record.validate_presence == true
    validate_is_absent(record) if record.validate_absence == true
  end


  private

  def validate_is_present(record)
    fields = [ :full_name ]
    fields << :title if record.is_a?(Defendant)
    fields += [:street, :postcode] unless record.is_a?(Defendant) && record.property_address == 'yes'
    
    fields.each do |field|
      record.errors[field] << "must be entered" if record.send(field).blank?
    end
  end



  def validate_is_absent(record)
    fields = record.is_a?(Defendant) ? [:title, :full_name, :street, :postcode] : [:full_name, :street, :postcode]
    fields.each do |field|
      record.errors[field] << "must not be entered if number of claimants is 1" if record.send(field).present?
    end
  end

end