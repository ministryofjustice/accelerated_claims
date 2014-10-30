require 'yaml'

# PostcodeLookupProxy API

# pclp = PostcodeLookupProxy.new("AB126FG")
# pclp.valid?         # => true
# pclp.lookup         # => true if http result was successful, otherwise false
# pclp.empty?         # => false if any addresses returned
# pclp.errors?        # => false if the result code from the remote service was successful, otherwise false
# pclp.result_code    # => the result_code returned from the remote service
# pclp.result_message # => the result message returned from the remote service
# pclp.result_set     # => array of address hashes  [ { 'address' => 'line 1;;line 2;;line 3', 'postcode' => 'ID1 1QQ'}, ... ]
#

class PostcodeLookupProxy

  @@dummy_postcode_results = YAML.load_file("#{Rails.root}/config/dummy_postcode_results.yml") 

  attr_reader :result_set, :result_code, :result_message

  def initialize(postcode, valid_countries, use_live_data = false)
    @postcode        = UKPostcode.new(postcode)
    @valid           = @postcode.valid?
    @result_set      = nil
    config           = YAML.load_file("#{Rails.root}/config/ideal_postcodes.yml")
    @url             = config['url']
    @api_key         = config['api_key']
    @timeout         = config['timeout']
    @result_code     = nil
    @result_message  = nil
    @use_live_data   = use_live_data
    @valid_countries = valid_countries
  end


  def valid?
    @valid
  end

  def invalid?
    !valid?
  end

  def empty?
    raise "Call PostcodeProxyLookup#lookup before PostcodeProxyLookup.empty?" if @result_set.nil?
    @result_set.empty?
  end


  def lookup
    raise "Invalid Postcode" unless valid?
    @use_live_data == true ? production_lookup : development_lookup
  end

  def errors?
    @result_code != 2000
  end
  


  private

  def form_url
    "#{@url}#{@postcode.outcode}#{@postcode.incode}?api_key=#{@api_key}"
  end

  # returns dummy postcode result based on the first character of the second part of the postcode.
  # if 0 - returns an empty array, indicating no entries of the postcode, otherwise a dummy result set
  # if 1 - returns a dummy set of data relating to Scotland
  # if 9 - returns false to simulate a timeout or other remote service error
  def development_lookup
    case @postcode.incode.first.to_i
    when 0
      transform_api_response(dummy_postcode_not_found_result_set)
      return true
    when 9 
      @result_set = nil
      @result_code = 9001
      @result_message = 'service not available'
      return false
    else
      index = @postcode.incode.first.to_i % @@dummy_postcode_results.size 
      result_set = transform_api_response(dummy_result_set(index))
      if country_valid?(result_set)
        return true
      else
        @result_set = nil
        @result_code = 9404
        @result_message = country_from_result_set(result_set)
        return false
      end
    end
  end


  def country_from_result_set(result_set)
    result_set.first['country']
  end

  def country_valid?(result_set)
    return true if @valid_countries.empty?
    @valid_countries.include?(country_from_result_set(result_set))
  end


  def dummy_result_set(index)
    OpenStruct.new(status: 200, body: { 'result' => @@dummy_postcode_results[index], 'code' => '2000', 'message' => 'Success' }.to_json)
  end


  def dummy_postcode_not_found_result_set
    OpenStruct.new(status: 200, body: { 'code' => '4040', 'message' => 'postcode not found' }.to_json)
  end

  

  def production_lookup
    result = true
    api_response = nil
    
    begin
      Timeout::timeout(@timeout) do
        api_response = Excon.get(form_url())
      end
      
    rescue Timeout::Error
      result = false
      @result_code = 9001
      @result_message = "Request timed out"
      @result_set = ""
    end

    if result == true 
      if api_response.status == 200 || api_response.status == 404
        transform_api_response(api_response)
      else
        @result_code = "9#{api_response.status}".to_i
        @result_message = "Error response from remote service"
        @result_set = ""
        result = false
      end
    end
    result
  end



  def transform_api_response(api_response)
    response_body = ActiveSupport::JSON.decode(api_response.body)
    @result_code = response_body['code']
    @result_message = response_body['message'].to_i
    if @result_code.to_i == 4040
      api_results = []
    else
      api_results = response_body['result']
    end
    @result_set = api_results.map { |res| transform_api_address(res) }
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