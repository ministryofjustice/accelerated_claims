class ContinuationSheet

  @@indentation = 4

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


  def left_side
    str = ''
    if any_claimants?
      str += claimants_header
      @claimants.each { |c| str += c.indented_details(@@indentation) }
    end
    str
  end


end