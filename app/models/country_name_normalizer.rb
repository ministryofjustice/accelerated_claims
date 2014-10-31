class CountryNameNormalizer

  def initialize(params)
    @country_params = params[:vc]
  end
  

  def normalize
    return [] if @country_params.nil?
    countries = @country_params.split(' ')
    countries.map{ |c| normalize_country_name(c) }
  end

  private 

  def normalize_country_name(country_name)
    titleize_main( country_name.gsub('_', ' ') )
  end

  def titleize_main(country_name)
    words = country_name.split(' ')
    words.map{ |w| w == 'of' ? w : w.capitalize }.join(' ')
  end


end