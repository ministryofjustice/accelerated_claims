
class ClaimantCollection


  def initialize(num_claimants, claim_params)
    @num_claimants = num_claimants
    @claimants = {}
    populate_claimants(claim_params)
  end


  def get(index)
    @claimants[index]
  end

  def put(index, claimant)
    @claimants[index] = claimant
  end


  private

  def populate_claimants(claim_params)
    (1..@num_claimants).each { | i | populate_claimant(i, claim_params) }
  end



  def populate_claimant(index, claim_params)
    claimant_params = claim_params["claimant_#{index}"]
    @claimants[index] = Claimant.new(claim_params)
  end
  


end