module PostcodeLookup
  module Country
    def self.for_postcode(postcode)
      (postcode.country['name'] || UKPostcode.parse(postcode.postcode).country).to_s
    end

    def self.params(countries_allowed)
      if countries_allowed.present? && countries_allowed != 'all'
        transform_countries( {vc: countries_allowed} )
      else
        'all'
      end
    end

    def self.transform_countries(params)
      CountryNameNormalizer.new(params).normalize
    end

    def self.valid?(allowed, postcode)
      allowed = Array(allowed).flatten.map{|c| c.downcase}
      allowed.include?('all') || allowed.include?(Country.for_postcode(postcode).downcase)
    end

    def self.if_valid(postcode, allowed_countries, &block)
      if Country.valid?(allowed_countries, postcode)
        block.call
      else
        invalid_country_status(Country.for_postcode(postcode))
      end
    end

    def self.invalid_country_status(country)
      if country != 'unknown'
        Status.new( message: country, code: 4041, http_status: 200 )
      else
        Status.new( message: 'Postcode Not Found', code: 4040, http_status: 404)
      end
    end

  end

end