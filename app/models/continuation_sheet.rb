class ContinuationSheet


  def initialize(claimants, defendants)
    @claimants = claimants
    @defendants = defendants
  end
  

  def empty?
    @claimants.empty? && @defendants.empty?
  end


  def any_defendants?
    @defendants.any?
  end


  def any_claimants?
    @claimants.any?
  end

end