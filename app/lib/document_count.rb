class DocumentCount

  def initialize json
    @json = json
  end

  def add
    counter = 1
    @json['defendant_two_address'].present? ? (counter += 1) : (counter)
    ( 1 .. ClaimantCollection.max_claimants ).each { |i|  counter += 1 if @json["claimant_#{i}_address"].present? }
    @json['copy_number'] = (counter += 1)
    @json
  end
end
