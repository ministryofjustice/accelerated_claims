module PostcodeLookup
  class DummyClient
    attr_accessor :dummy_postcodes, :status

    def initialize
      self.dummy_postcodes = load_dummy_postcodes
    end

    def lookup_postcode(postcode)
      dummy_lookup(postcode)
    end

    private

      def dummy_lookup(postcode)
        key_digit = postcode.gsub(' ', '')[-3]
        case key_digit
        when '0'
          self.status = Status.new( message: 'Postcode Not Found', code: 4040, http_status: 404 )
          MockPostcode.new(postcode, [], nil, false)
        when '9'
          self.status = Status.new( message: 'Service Unavailable', code: 5030, http_status: 503 )
          MockPostcode.new(postcode, [], nil, false)
        when /[a-z]/i
          self.status = Status.new( message: 'Invalid Postcode', code: 4220, http_status: 422 )
          MockPostcode.new(postcode, [], nil, false)
        else
          addresses = self.dummy_postcodes[key_digit.to_i % 6]
          country = addresses[0]['country']
          MockPostcode.new(postcode, addresses, country, true)
          #self.status = [{message: 'Success', code: 2000, result: pc.addresses}, 200]
        end
      end

      def load_dummy_postcodes
        yaml_file_content = File.read(Rails.root.join('config','dummy_postcode_results.yml'))
        YAML.load(yaml_file_content)
      end
  end

end



class MockPostcode
  attr_accessor :addresses, :country, :valid, :postcode

  def initialize(postcode, addresses, country, valid)
    self.addresses = addresses.map{ |addr| self.class.format_dummy_address(addr) }
    self.country = {'name' => country}
    self.valid = valid
    self.postcode = postcode
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

  def invalid?
    !valid?
  end
end