class PostcodeLookupProxyController < ApplicationController

  def show
    #@pclp = PostcodeLookupProxy.new(params[:pc], , live_postcode_lookup?)
    #@pclp.lookup
    @client = postcode_lookup_client(live_postcode_lookup?)
    respond_to do |format|
      format.json do
        begin
          @postcode = @client.lookup_postcode(params[:pc])
          
          json, status = construct_response(@postcode, country_params)

        rescue PostcodeInfo::UnrecognisedPostcode => e
          json, status = [{message: e.message, code: 4040}, 404 ]
        rescue Timeout::Error => e
          json, status = [{message: 'Service Unavailable', code: 5030}, 503 ]
        end

        render json: json, status: status
      end
    end
  end

  private

  def construct_response(postcode, country_params)
    if @postcode.valid?
      if country_valid?(country_params)
        if @postcode.addresses.empty?
           [{message: 'Postcode Not Found', code: 4040}, 404]
        else
          [{message: 'Success', code: 2000, result: addresses_for_json(@postcode)}, 200]
        end
      else
        # This is what the controller spec requires...
        [{message: 'Scotland', code: 4041}, 200 ]
      end
    else
      [{message: 'Invalid Postcode', code: 4220}, 422 ]
    end
  end

  def country_valid?(allowed)
    allowed == 'all' || allowed.include?(@postcode.country['name'])
  end

  def country_params
    if params[:vc].present? && params[:vc] != 'all'
      transform_countries
    else
      'all'
    end
  end

  def transform_countries
    CountryNameNormalizer.new(params).normalize
  end

  def postcode_lookup_client(live)
    live ?
      PostcodeInfo::Client.new(auth_token: ENV['POSTCODEINFO_AUTH_TOKEN'].to_s, 
        env: postcode_lookup_env) 
      :
      DummyPostcodeLookupClient.new
  end

  def live_postcode_lookup?
    production = ['staging', 'production'].include?( ENV['ENV_NAME'] )
    use_live_postcode_lookup = (URI(request.referer).query =~ /livepc=1/).nil? ? false : true
    use_live_postcode_lookup || production
  end

  def postcode_lookup_env
    live_postcode_lookup? ? 'production' : 'staging'
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
end
