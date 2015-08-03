class PostcodeLookupFacade
  attr_accessor :live, :allowed_countries, :status

  def initialize(allowed_countries, live=false)
    self.allowed_countries = country_params(allowed_countries)
    self.live = live
  end

  def lookup(postcode)
    begin
      client = postcode_lookup_client(self.live)
      postcode_obj = client.lookup_postcode(postcode)
      log_lookup(client)
      self.status = results_hash(postcode_obj, client)

    rescue PostcodeInfo::UnrecognisedPostcode => e
      self.status = [{message: e.message, code: 4040}, 404 ]
    rescue Timeout::Error => e
      LogStuff.info(:postcode_lookup, {:timeout=>true, :endpoint=>client.api_url}) if live
      self.status = [{message: 'Service Unavailable', code: 5030}, 503 ]
    end
    
    postcode_obj
  end

  def norm(postcode)
    UKPostcode.parse(postcode).to_s
  end

  def status_code
    self.status[0][:code]
  end

  def status_message
    self.status[0][:message]
  end

  def result_set
    self.status[0][:result]
  end

  protected

    def log_lookup(client)
      LogStuff.info(:postcode_lookup, {:timeout=>false, :endpoint=>client.api_url}) if live
    end

    def postcode_lookup_client(live)
      live ?
        PostcodeInfo::Client.new(auth_token: ENV['POSTCODEINFO_AUTH_TOKEN'].to_s, 
          env: postcode_lookup_env) 
        :
        DummyPostcodeLookupClient.new
    end

    def country_valid?(allowed, postcode)
      allowed = Array(allowed).flatten.map{|c| c.downcase}
      allowed.include?('all') || allowed.include?(country_for_postcode(postcode))
    end

    def country_for_postcode(postcode)
      (postcode.country['name'] || UKPostcode.parse(postcode.postcode).country).to_s.downcase
    end

    def country_params(countries_allowed)
      if countries_allowed.present? && countries_allowed != 'all'
        transform_countries( {vc: countries_allowed} )
      else
        'all'
      end
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

    def with_country_validation(postcode, &block)
      if country_valid?(self.allowed_countries, postcode)
        block.call
      else
        country = country_for_postcode(postcode)
        if postcode.country[:name] != 'unknown'
          [{message: country, code: 4041}, 200 ]
        else
          [{message: 'Postcode Not Found', code: 4040}, 404]
        end
      end
    end

    def with_postcode_validation(postcode, &block)
      if postcode.respond_to?(:valid?) && postcode.valid?
        block.call
      else
        [{message: 'Invalid Postcode', code: 4220}, 422 ]
      end
    end

    def results_hash(postcode, client)
      if client.respond_to?(:status) && client.status.present?
        with_country_validation(postcode){ client.status }
      else 
        with_postcode_validation(postcode) do
          with_country_validation(postcode) do
            if postcode.addresses.empty?
               [{message: 'Postcode Not Found', code: 4040}, 404]
            else
              [{message: 'Success', code: 2000, result: addresses_for_json(postcode)}, 200]
            end
          end
        end
      end
    end

    def transform_countries(params)
      CountryNameNormalizer.new(params).normalize
    end
  
end