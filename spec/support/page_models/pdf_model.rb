class PdfModel
  include RSpec::Matchers

  def load(filename)
    @generated_values = values_from_pdf(filename)
  end

  def assert_pdf_is_correct(expected_values)
    expected_values.each do |field, value|
      "#{field}: #{@generated_values[field]}".should == "#{field}: #{value}"
    end
  end

  def write_hash_to_file(filename)
    File.open(filename,'w') do |f|
      data = JSON.pretty_generate(@generated_values)
      data.gsub!(/"([^"]+)":/, '\1:')
      data.gsub!('null','nil')

      f.write data
    end
  end

private
  def values_from_pdf file
    fields = `pdftk #{file} dump_data_fields`
    fields.strip.split('---').each_with_object({}) do |fieldset, hash|
      field = fieldset[/FieldName: ([^\s]+)/,1]
      value = fieldset[/FieldValue: (.+)/,1]
      value.gsub!('&#13;',"\n") if value.present?
      hash[field] = value if field.present?
    end
  end
end