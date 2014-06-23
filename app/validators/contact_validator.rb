class ContactValidator < ActiveModel::Validator


  def validate(record)
    validate_is_present(record) if record.validate_presence == true
    validate_is_absent(record) if record.validate_absence == true
  end


  private

  def validate_is_present(record)
    [:full_name, :street, :postcode].each do |field|
      record.errors[field] << "must be entered" if record.send(field).blank?
    end
  end



  def validate_is_absent(record)
    [:full_name, :street, :postcode].each do |field|
      record.errors[field] << "must not be entered if number of claimants is 1" if record.send(field).present?
    end
  end

end