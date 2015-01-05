module SharedPartyMethods
  def validate_are_present(*fields)
    fields.each do |field|
      errors.add(field, "Enter #{subject_description}'s #{display_name(field)}") if self.send(field).blank?
    end
  end
end