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
    if Rails.env.production?
      production_lookup
      
    else
      development_lookup
    end

  end
  


  private

  def production_lookup
    raise "Postcode lookup in Production not yet implemented"
  end


  def development_lookup
    index = @postcode.incode.first.to_i % @@dummy_postcode_results.size 
    @@dummy_postcode_results[index]
  end

end