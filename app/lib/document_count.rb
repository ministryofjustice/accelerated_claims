class DocumentCount

  def initialize json
    @json = json
  end

  def add
    counter = 0
    @json['defendant_two_address'].present? ? (counter += 2) : (counter += 1)
    @json['claimant_two_address'].present? ? (counter += 2) : (counter += 1)
    @json['copy_number'] = (counter += 1)
    @json
  end
end
