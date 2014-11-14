require 'w3c_validators'

include W3CValidators

def remote_test?
  ENV['env'].present?
end

def form_date field, date
  {
    "#{field}(3i)" => date.try(:day),
    "#{field}(2i)" => date.try(:month),
    "#{field}(1i)" => date.try(:year)
  }
end

def load_stringified_hash_from_file(filename)
  contents = IO.read(filename)
  data = recursively_stringify_keys(eval contents)
  data
end

def recursively_stringify_keys(hash)
  op = {}
  hash.each do |k, v|
    if v.class == Hash
      hash[k] = recursively_stringify_keys(v)
    end
    op[k.to_s] = hash.delete(k)
  end
  op
end

def load_fixture_data(filename)
  load_stringified_hash_from_file(filename)
end

def load_expected_data(data_file)
  data_file =~ /.*scenario_([0-9]{2})_(both|js|non-js)_data/
  dataset_number = sprintf('%02d', $1.to_i)
  filename = "spec/fixtures/scenario_#{dataset_number}_results.rb"
  results = load_stringified_hash_from_file(filename)
end

def assert_hash_is_correct(generated_values, expected_values)
  expected_values.each do |field, value|
    expect("#{field}: #{generated_values[field]}").to eq("#{field}: #{value}")
  end
end

def find_it element, id
  @elements ||= {}
  @elements[element] ||= page.all(:xpath, "/html/body//#{element}", visible: false).each_with_object({}) {|e, h| h[e['id']] = e if e['id'] }

  if @elements[element][id].nil?
    puts "#{id} #{element} cannot be found"
  else
    @elements[element][id]
  end
end

def submit_claim
  if input = find_it('input', 'submit')
    input.click
  end
end

def write_hash_to_file(filename, object)
  File.open(filename,'w') do |f|
    data = JSON.pretty_generate(object)
    data.gsub!(/"([^"]+)":/, '\1:')
    data.gsub!('null','nil')

    f.write data
  end
end

def summary_data_file data_file
  "#{data_file.sub(/_(both|js|non-js)/,'').chomp('_data.rb')}_summary_results.rb"
end

def find_summary_values page, data_file
  summary_values = {}
  page.all('.summary-field').map do |p|
    v= p.find('.summary-value')
    attribute = v['id'].sub('#','').to_sym
    summary_values[attribute] = [p.find('.summary-label').text, v.text]
  end

  if ENV.key?('save_summary_data')
    file = summary_data_file data_file
    puts "writing: #{file}"
    write_hash_to_file file, summary_values
  end

  summary_values
end

def load_expected_summary_values data_file
  file = summary_data_file data_file
  results = IO.read(file)
  eval results
end

# options[:debug] = turn on debug output

def validate_view(response, options)
  WebMock.disable_net_connect!(:allow => [ /validator.w3.org/ ])
  @validator = MarkupValidator.new

  # turn on debugging messages
  @validator.set_debug!(true) if options[:w3c_debug]

  results = @validator.validate_text(response.body)

  if results.errors.length > 0 && options[:w3c_debug]
    puts '*****************'
    puts response.body
    puts '*****************'

    results.errors.each do |err|
      puts err.to_s
    end
    puts 'Debugging messages'

    results.debug_messages.each do |key, value|
      puts "  #{key}: #{value}"
    end
  end
  results
end