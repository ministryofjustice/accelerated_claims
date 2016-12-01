class PdfModel
  include RSpec::Matchers

  def load(filename)
    @generated_values = values_from_pdf(filename)
    puts "read claimant_1_address as `#{@generated_values['claimant_1_address']}` from `#{filename}`"
  end

  def assert_pdf_is_correct(expected_values)
    expected_values.each do |field, value|
      generated = @generated_values[field]
      generated = generated.gsub("\n\n","\n") if generated.is_a?(String)

      if ENV["env"] == 'production'
        value = generated if field == 'property_postcode1'
        value = generated if field == 'property_postcode2'
        value = generated if field == 'defendant_1_postcode1'
        value = generated if field == 'defendant_1_postcode2'
        value = generated if field == 'defendant_2_postcode1'
        value = generated if field == 'defendant_2_postcode2'
        value.gsub!(/EY99\ 1XX/, 'SW1H 9AJ') if field.match(/(right|left)|_panel(0|1)/)
      end
      expect("#{field}: #{generated}").to eq("#{field}: #{value}")
    end
  end

  def generated_values
    @generated_values
  end

private
  def values_from_pdf file
    puts "pdftk getting data fields from #{file}"
    fields = `pdftk #{file} dump_data_fields`
    fields.strip.split('---').each_with_object({}) do |fieldset, hash|
      field = fieldset[/FieldName: ([^\s]+)/,1]
      value = fieldset[/FieldValue: (.+)/,1]
      value.gsub!('&#13;',"\n") if value.present?
      hash[field] = value if field.present?
    end
  end
end
