class DummyPostcodeLookupClient
  attr_accessor :dummy_postcodes, :response_body

  def initialize
    self.dummy_postcodes = load_dummy_postcodes
  end

  def lookup_postcode(postcode)
    dummy_lookup(postcode)
  end

  private

    def dummy_lookup(postcode)
      key_digit = postcode.gsub(' ', '')[-3].to_i
      case key_digit
      when 0
        {'status' => 404, 'message' => 'No matching postcodes', 'result' => []}
        MockPostcode.new([], nil, true)
      when 9
        self.result_set = {'status' => 503, 'message' => 'Service Unavailable'}
        MockPostcode.new([], nil, false)
      else
        addresses = self.dummy_postcodes[key_digit % 6]
        country = addresses[0]['country']
        MockPostcode.new(addresses, country, true)
      end
    end

    def load_dummy_postcodes
      yaml_file_content = File.read(Rails.root.join('config','dummy_postcode_results.yml'))
      YAML.load(yaml_file_content)
    end

end



class MockPostcode
  attr_accessor :addresses, :country, :valid

  def initialize(addresses, country, valid)
    self.addresses = addresses.map{ |addr| self.class.format_dummy_address(addr) }
    self.country = {'name' => country}
    self.valid = valid
  end

  def self.format_dummy_address(addr)
    {
      :formatted_address => [addr['line_1'].presence, addr['line_2'].presence, addr['post_town'].presence].compact.join(';;'),
      :postcode => addr['postcode'],
      :country => addr['country']
    }
  end

  def valid?
    self.valid
  end
end