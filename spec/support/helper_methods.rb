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
  path = File.expand_path(File.join(__FILE__, '..', '..', 'fixtures'))
  contents = IO.read(File.join(path, filename))
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

def load_fixture_data(dataset_number)
  filename = "scenario_#{dataset_number}_data.rb"
  load_stringified_hash_from_file(filename)
end

def load_expected_data(dataset_number)
  filename = "scenario_#{dataset_number}_results.rb"
  load_stringified_hash_from_file(filename)
end

def assert_hash_is_correct(generated_values, expected_values)
  expected_values.each do |field, value|
    expect("#{field}: #{generated_values[field]}").to eq("#{field}: #{value}")
  end
end

