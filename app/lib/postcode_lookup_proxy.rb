require 'yaml'

# PostcodeLookupProxy API

# pclp = PostcodeLookupProxy.new("AB126FG", ['England', 'Wales'], true)    or  PostcodeLookupProxy.new("AB126FG", [], true)
# pclp.lookup             # => true if http result was successful, otherwise false
# pclp.result_set         # => The JSON that is to be returned by the controller
# pclp.http_status_code   # => the HTTP status code that the controller should return
#
class PostcodeLookupProxy

  @@dummy_postcode_results = YAML.load_file("#{Rails.root}/config/dummy_postcode_results.yml")

  attr_reader :result_set, :result_code, :result_message, :http_status

  def initialize(postcode, valid_countries, use_live_data = false)
    @postcode                 = UKPostcode.parse(postcode)
    @valid                    = @postcode.valid?
    @result_set               = nil
    @url                      = ENV['POSTCODE_LOOKUP_API_URL']
    @api_key                  = ENV['POSTCODE_LOOKUP_API_KEY']
    @timeout                  = 3.0
    @api_result_set           = nil
    @use_live_data            = use_live_data
    @valid_countries          = valid_countries
    @http_status              = nil
    @validation_error_message = nil
  end

  def valid?
    @valid
  end

  def invalid?
    !valid?
  end

  def lookup
    if valid?
      if @use_live_data
        @api_result_set = production_lookup
      else
        @api_result_set = development_lookup
      end
    else
      @api_result_set = invalid_postcode_response
    end
    transform_api_result_set
    true
  end

  def norm
    @postcode.to_s
  end

  private

  # transforms @api_result_set which is returned by the api to @result_set whcih the controller can return
  #
  def transform_api_result_set
    case @api_result_set['code']
    when 2000
      transform_successful_result_set
    else
      transform_erroneous_result_set
    end
  end

  def production_lookup
    @api_response = Rails.cache.fetch("#{form_url}", expires_in: 1.hour) do
      postcode_lookup_query
    end
  end

  def postcode_lookup_query
    begin
      Timeout::timeout(@timeout) do
        @api_response = ActiveSupport::JSON.decode( Excon.get(form_url).body)
        record_log_with_timeout(false)
        @api_response
      end
    rescue Timeout::Error
      record_log_with_timeout(true)
      @api_response = service_unavailable_response
    end
  end

  def record_log_with_timeout(timeout)
    LogStuff.info(:postcode_lookup, timeout: timeout, endpoint: @url) { "Postcode Lookup" }
  end

  # returns dummy postcode result based on the first character of the second part of the postcode.
  # if 0 - returns an empty array, indicating no entries of the postcode, otherwise a dummy result set
  # if 1 - returns false to simulate a credits running out
  # if 9 - returns false to simulate a timeout or other remote service error
  # otherwise returns a data set as documented at the top of dummy_postcode_results.yml
  #
  def development_lookup
    case @postcode.incode.first.to_i
    when 0
      return no_such_postcode_response
    when 1
      return service_out_of_credits_response
    when 9
      return service_unavailable_response
    else
      index = @postcode.incode.first.to_i % @@dummy_postcode_results.size
      wrap_dummy_result_set( @@dummy_postcode_results[index] )
    end
  end

  def transform_successful_result_set
    if country_valid?
      addresses = @api_result_set['result'].map { |res| transform_api_address(res) }
      @result_set = { 'code' => 2000, 'message' => 'Success', 'result' => addresses }
    else
      @result_set = { 'code' => 4041, 'message' => api_result_set_country }
    end
    @http_status = 200
  end

  def transform_erroneous_result_set
    @result_set = @api_result_set
    @http_status = case @api_result_set['code']
    when 4040
      404
    when 4220
      422
    when 5030, 4020
      503
    else
      500
    end
  end

  def country_valid?
    @valid_countries == ['All'] || @valid_countries.include?(api_result_set_country)
  end

  def api_result_set_country
    @api_result_set['result'].first['country']
  end

  def form_url
    "#{@url}#{@postcode.outcode}#{@postcode.incode}?api_key=#{@api_key}"
  end

  def wrap_dummy_result_set(result_set)
    {
      "result"=> result_set,
      "code"=>2000,
      "message"=>"Success"
    }
  end

  def service_unavailable_response
    {"code"=>5030, "message"=>"Service Unavailable"}
  end

  def service_out_of_credits_response
    {"code"=>4020, "message"=>"Key balance depleted."}
  end

  def invalid_postcode_response
    {"code"=>4220, "message"=>"Invalid Postcode"}
  end

  def no_such_postcode_response
    {'code' => 4040, 'message' => 'Postcode Not Found' }
  end

  def transform_api_address(res)
    address = res['line_1']
    address += add_unless_blank(res, 'line_2')
    address += add_unless_blank(res, 'line_3')
    address += add_unless_blank(res, 'post_town')
    postcode = res['postcode']
    country = res['country']
    { 'address' => address, 'postcode' => postcode, 'country' => country }
  end

  def add_unless_blank(res, key)
    res[key].blank? ? '' : ";;#{res[key]}"
  end

end
