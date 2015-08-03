
class PostcodeLookupProxy
  attr_accessor :given_postcode, :retrieved_postcode, :allowed_countries, 
                :live, :client, :result_set, :config, :dummy_postcodes

  def initialize(postcode, allowed_countries, live=false)
    self.allowed_countries = allowed_countries
    self.retrieved_postcode = nil
    self.given_postcode = postcode
    self.result_set = nil
    self.config = load_config
    self.client = configure_client
    self.live = live
  end

  def lookup
    self.live ? live_lookup : dummy_lookup
  end

  def lookup_postcode()
    begin
      self.retrieved_postcode = self.client.lookup_postcode(self.given_postcode)
      self.result_set = {'code' => 200, 'result'=> format_addresses}
    rescue PostcodeInfo::UnrecognisedPostcode => e
      self.retrieved_postcode = nil
      self.result_set = {'code' => 4040, 'message'=> 'Unrecognized Postcode'}
    end
  end

  

  protected
    def dummy_lookup
      DummyPostcodeLookupClient.new
    end
    
    def load_config
      yaml_file_content = File.read(Rails.root.join('config','postcode_info_client.yml'))
      YAML.load(yaml_file_content)['postcode_info']
    end

    def configure_client
      PostcodeInfo::Client.new(auth_token: auth_token, env: postcode_lookup_env)
    end

    def auth_token
      @auth_token ||= (ENV['POSTCODEINFO_AUTH_TOKEN'] || self.config['default_auth_token'])
    end

    def postcode_lookup_env
      self.live ? 'production' : 'staging'
    end

    def format_addresses
      self.retrieved_postcode.addresses.map{|addr| 
        {
          'address'=> addr[:formatted_address].split("\n")[0..-2].join(';'),
          'postcode' => addr[:postcode],
          'country' => self.retrieved_postcode.country
        }
      }
    end

    def format_dummy_address(addr)
      {
        'address' => [addr['line_1'], addr['post_town']].join(';;'),
        'postcode' => addr['postcode'],
        'country' => addr['country']
      }
    end
end