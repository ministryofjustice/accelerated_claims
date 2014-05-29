class DocumentCount

  def initialize json
    @json = json
  end

  def add
    counter = 0
    (blank_and_present? 'defendant_two_address') ? (counter += 2) : (counter += 1)
    (blank_and_present? 'claimant_two_address') ? (counter += 2) : (counter += 1)
    @json['copy_number'] = (counter += 1)
    @json
  end

  private

  def blank_and_present? attr
    return false unless (@json.key? attr)
    !@json["#{attr}"].gsub('\n', '').blank?
  end
end
