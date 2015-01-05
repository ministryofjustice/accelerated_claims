module SharedPartyMethods
  def validate_are_present(*fields)
    fields.each do |field|
      error_message = "Enter #{subject_description}'s #{display_name(field)}"
      errors.add(field, error_message) if send(field).blank?
    end
  end
end
