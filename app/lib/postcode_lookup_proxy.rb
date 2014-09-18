class PostcodeLookupProxy

  @@dummy_postcode_results = YAML.load_file("#{Rails.root}/config/dummy_postcode_results.yml")

  def initialize(postcode)
    @postcode = UKPostcode.new(postcode)
    @valid = @postcode.valid?
  end


  def valid?
    @valid
  end


  def lookup
    if valid?
      if Rails.env.production?
        production_lookup
      else
        development_lookup
      end
    else
      :bad_request
    end
  end
  


  private

  def production_lookup
    raise NotImplementedError.new("Postcode lookup not yet implemented")
  end


  # returns dummy postcode result based on the first character of the second part of the postcode.
  # if zero - returns an empty array, indicating no entries of the postcode, otherwise a dummy result set
  #
  def development_lookup
    if @postcode.incode.first.to_i == 0
      return []
    end
    index = @postcode.incode.first.to_i % @@dummy_postcode_results.size 
    @@dummy_postcode_results[index]
  end

end