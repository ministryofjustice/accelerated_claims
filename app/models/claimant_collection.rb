
class ClaimantCollection


  def initialize(num_claimants, claim_params)
    @num_claimants = num_claimants
    @claimants = {}
    populate_claimants(claim_params['claim'])
  end

  # returns the specified claimant (note: index starts at 1 )         
  def [](index)
    claimant = @claimants[index]
    raise ArgumentError.new "No such index: #{index}" if claimant.nil?
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


  private

  def populate_claimants(claim_params)
    (1..@num_claimants).each { | i | populate_claimant(i, claim_params) }
  end



  def populate_claimant(index, claim_params)
    claimant_params = claim_params["claimant_#{index}"]
    raise ArgumentError.new "Unable to find claimant_#{index} in the params" if claimant_params.nil?
    @claimants[index] = Claimant.new(claimant_params)
  end
  


end