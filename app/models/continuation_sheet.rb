class ContinuationSheet


  def initialize(claimants, defendants)
    @claimants = claimants
    @defendants = defendants
  end
  

  def empty?
    @claimants.empty? && @defendants.empty?
  end

end