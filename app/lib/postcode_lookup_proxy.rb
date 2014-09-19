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

  def production_lookup
    raise NotImplementedError.new("Postcode lookup not yet implemented")
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