class DocumentCount

  def initialize json
    @json = json
  end

  def add
    counter = 1
    ( 1 .. DefendantCollection.max_defendants ).each { |i| counter += 1 if @json["defendant_#{i}_address"].present? }
    ( 1 .. ClaimantCollection.max_claimants ).each { |i|  counter += 1 if @json["claimant_#{i}_address"].present? }
    @json['copy_number'] = (counter)
    @json
  end
end
