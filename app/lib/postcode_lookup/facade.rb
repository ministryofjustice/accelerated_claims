module PostcodeLookup
  class Facade
    attr_accessor :live, :allowed_countries, :status

    def initialize(allowed_countries, live=false)
      self.allowed_countries = Country.params(allowed_countries)
      self.live = live
    end

    def lookup(postcode)
      begin
        client = postcode_lookup_client(self.live)
        postcode_obj = perform_lookup!(postcode, client)

      rescue PostcodeInfo::UnrecognisedPostcode => e
        self.status = Status.new( message: e.message, code: 4040, http_status: 404 )
      rescue Timeout::Error => e
        log_timeout(client) if self.live
        self.status = Status.new( message: 'Service Unavailable', code: 5030, http_status: 503 )
      end
      
      postcode_obj
    end

    def norm(postcode)
      UKPostcode.parse(postcode).to_s
    end

    protected

      def perform_lookup!(postcode, client)
        postcode_obj = client.lookup_postcode(postcode)
        log_lookup(client)  if self.live
        self.status = result_status(postcode_obj, client)
        postcode_obj
      end

      def log_timeout(client)
        LogStuff.info(:postcode_lookup, {:timeout=>true, :endpoint=>client.api_url})
      end

      def log_lookup(client)
        LogStuff.info(:postcode_lookup, {:timeout=>false, :endpoint=>client.api_url})
      end

      def postcode_lookup_client(live)
        live ?
          PostcodeInfo::Client.new(auth_token: ENV['POSTCODEINFO_AUTH_TOKEN'].to_s, 
            env: postcode_lookup_env) 
          :
          PostcodeLookup::DummyClient.new
      end

      def postcode_lookup_env
        self.live ? 'production' : 'staging'
      end

      def addresses_for_json(postcode)
        postcode.addresses.map{ |address|
          {
            'address' => address[:formatted_address].to_s.split("\n").join(';;'),
            'country' => address[:country] || postcode.country['name'],
            'postcode' => address[:postcode]
          }
        }
      end
      
      def with_postcode_validation(postcode, &block)
        if postcode.respond_to?(:valid?) && postcode.valid?
          block.call
        else
          Status.new( message: 'Invalid Postcode', code: 4220, http_status: 422 )
        end
      end

      def result_status(postcode, client)
        if client.respond_to?(:status) && client.status.present?
          Country.if_valid(postcode, allowed_countries){ client.status }
        else 
          with_postcode_validation(postcode) do
            Country.if_valid(postcode, allowed_countries){ address_status(postcode) }
          end
        end
      end      

      def address_status(postcode)
        if postcode.addresses.empty?
          Status.new( message: 'Postcode Not Found', code: 4040, http_status: 4040)
        else
          Status.new( message: 'Success', code: 2000, result: addresses_for_json(postcode), http_status: 200)
        end
      end
  end
end