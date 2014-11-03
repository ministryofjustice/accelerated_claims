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
    binding.pry
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

