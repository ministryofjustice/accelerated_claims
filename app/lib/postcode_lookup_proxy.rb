require 'yaml'

# PostcodeLookupProxy API

# pclp = PostcodeLookupProxy.new("AB126FG")
# pclp.lookup             # => true if http result was successful, otherwise false
# pclp.result_set         # => The JSON that is to be returned by the controller
# pclp.http_status_code   # => the HTTP status code that the controller should return
#
class PostcodeLookupProxy

  @@dummy_postcode_results = YAML.load_file("#{Rails.root}/config/dummy_postcode_results.yml") 

  attr_reader :result_set, :result_code, :result_message, :http_status

  def initialize(postcode, valid_countries, use_live_data = false)
    @postcode        = UKPostcode.new(postcode)
    @valid           = @postcode.valid?
    @result_set      = nil
    config           = YAML.load_file("#{Rails.root}/config/ideal_postcodes.yml")
    @url             = config['url']
    @api_key         = config['api_key']
    @timeout         = config['timeout']
    @api_result_set  = nil
    @use_live_data   = use_live_data
    @valid_countries = valid_countries
    @http_status     = nil
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
    begin
      Timeout::timeout(@timeout) do
        @api_response = ActiveSupport::JSON.decode( Excon.get(form_url).body) 
      end
    rescue Timeout::Error
      @api_response = service_unavailable_response
    end
  end


  # returns dummy postcode result based on the first character of the second part of the postcode.
  # if 0 - returns an empty array, indicating no entries of the postcode, otherwise a dummy result set
  # if 9 - returns false to simulate a timeout or other remote service error
  # otherwise returns a data set as documented at the top of dummy_postcode_results.yml
  #
  def development_lookup
    case @postcode.incode.first.to_i
    when 0
      return no_such_postcode_response
    when 9 
      return service_unavailable_response
    else
      index = @postcode.incode.first.to_i % @@dummy_postcode_results.size 
      wrap_dummy_result_set( @@dummy_postcode_results[index] )
    end
  end






  def transform_successful_result_set
    addresses = @api_result_set['result'].map { |res| transform_api_address(res) }
    @result_set = { 'code' => 2000, 'message' => 'Success', 'result' => addresses }
    @http_status = 200
  end


  def transform_erroneous_result_set
    @result_set = @api_result_set
    @http_status = case @api_result_set['code']
    when 4040
      404
    when 4220
      422
    when 5030
      503
    else
      500
    end
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