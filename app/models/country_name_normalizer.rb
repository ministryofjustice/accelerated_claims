class CountryNameNormalizer

  def initialize(params)
    @country_params = params[:vc].gsub('+', ' ') if params.key?(:vc)
  end
  

  def normalize
    countries = @country_params.nil? ? [] : @country_params.split(' ')
    countries.map{ |c| normalize_country_name(c) }
  end

  def to_sentence
    result = normalize.to_sentence(last_word_connector: ' and ')
    result = 'UK' if result.blank?
    result
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