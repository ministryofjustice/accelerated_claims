class DocumentCount

  def initialize json
    @json = json
  end

  def add
    counter = 2
    @json['defendant_two_address'].present? ? (counter += 1) : (counter)
    @json["claimant_2_address"].present? ? (counter += 1 ) : (counter)
    @json["claimant_3_address"].present? ? (counter += 1 ) : (counter)
    @json["claimant_4_address"].present? ? (counter += 1 ) : (counter)
    @json['copy_number'] = (counter += 1)
    @json
  end
end
