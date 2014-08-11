
class ClaimantCollection


  @@max_claimants = 4

  def initialize(num_claimants, claim_params)
    @num_claimants = num_claimants
    @claimants = {}
    populate_claimants(claim_params)
  end

  # returns the specified claimant (note: index starts at 1 )         
  def [](index)
    claimant = @claimants[index]
    raise ArgumentError.new "No such index: #{index}" if index == 0
    claimant
  end

  def []=(index, claimant)
    raise ArgumentError.new "Invalid index: #{index}" if index == 0
    raise ArgumentError.new "Invalid index: #{index}" if index > @num_claimants
    @claimants[index] = claimant
  end

  def size
    @num_claimants
  end

  # returns a hash of claimants and models used in Claim#attributes_from_submodels
  def model_hash
    hash = {}
    (1..@num_claimants).each { |i|  hash["claimant_#{i}"] = 'Claimant' }
    hash
  end


  def as_json
    hash = {}
    @claimants.each do |index, claimant|
      hash["claimant_#{index}"] = claimant
    end
    hash.as_json
  end


  private

  def populate_claimants(claim_params)
    if claim_params.nil? || claim_params.empty?
      @claimants[1] = Claimant.new
    else
      (1..@@max_claimants).each { | i | populate_claimant(i, claim_params) }
    end
  end



  # we want to iterate through this until max-num-claimants.

  # for all those <= num_claimants, we wantto ensure data is there
  # for those above, we want to ensure data is not there, and not add the claimant in if its' not there.


  def populate_claimant(index, claim_params)
    claimant_params = claim_params["claimant_#{index}"]
    if index > @num_claimants
      unless claimant_params.nil?
        claimant_params['validate_absence'] = true
        @claimants[index] = Claimant.new(claimant_params)
      end
    else
      raise ArgumentError.new "Unable to find claimant_#{index} in the params" if claimant_params.nil?
      @claimants[index] = Claimant.new(claimant_params)
    end
  end
  


end