require 'yaml'

# PostcodeLookupProxy API

# pclp = PostcodeLookupProxy.new("AB126FG")
# pclp.valid?       # => true
# pclp.lookup       # => true, if result found, false if timeout or bad response
# pclp.empty?       # => false if any addresses returned
# pclp.result_set   # => array of addresses
#

class PostcodeLookupProxy

  @@dummy_postcode_results = YAML.load_file("#{Rails.root}/config/dummy_postcode_results.yml")

  attr_reader :result_set
  def initialize(postcode)
    @postcode   = UKPostcode.new(postcode)
    @valid      = @postcode.valid?
    @result_set = nil
    config      = YAML.load_file("#{Rails.root}/config/ideal_postcodes.yml")
    @url        = config['url']
    @api_key    = config['api_key']
    @timeout    = config['timeout']
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
    Rails.env.production? ? production_lookup : development_lookup
  end

  


  private

  def form_url
    "#{@url}#{@postcode.outcode}#{@postcode.incode}?api_key=#{@api_key}"
  end


  def production_lookup
    result = true
    api_response = nil
    
    begin
      Timeout::timeout(@timeout) do
        api_response = Excon.get(form_url())
        result = false if api_response.status != 200
      end
    rescue Timeout::Error
      result = false
    end

    if result == true
      @result_set = transform_api_response(api_response)
    end
    result
  end


  def transform_api_response(api_response)
    api_results = ActiveSupport::JSON.decode(api_response.body)['result']
    api_results.map { |res| transform_api_address(res) }
  end

  def transform_api_address(res)
    address = res['line_1']
    address += add_unless_blank(res, 'line_2')
    address += add_unless_blank(res, 'line_3')
    address += add_unless_blank(res, 'post_town')
    postcode = res['postcode']
    { 'address' => address, 'postcode' => postcode }
  end


  def add_unless_blank(res, key)
    res[key].blank? ? '' : ";;#{res[key]}"
  end


  # returns dummy postcode result based on the first character of the second part of the postcode.
  # if 0 - returns an empty array, indicating no entries of the postcode, otherwise a dummy result set
  # if 9 - returns false to simulate a timeout or other remote service error
  def development_lookup
    case @postcode.incode.first.to_i
    when 0
      @result_set =  []
      return true
    when 9 
      return false
    else
      index = @postcode.incode.first.to_i % @@dummy_postcode_results.size 
      @result_set = @@dummy_postcode_results[index]
      return true
    end
  end

end