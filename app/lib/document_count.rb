class DocumentCount

  def initialize json
    @json = json
  end

  def add
    counter = 0
    (@json.key? 'defendant_two_address') ? (counter += 2) : (counter += 1)
    (@json.key? 'claimant_two_address') ? (counter += 2) : (counter += 1)
    @json['number-copies'] = (counter += 1)
    @json
  end
end
