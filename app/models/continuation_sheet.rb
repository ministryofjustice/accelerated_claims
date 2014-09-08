
# Class to format the output on the continuation sheet for additional claimants and defendants

class ContinuationSheet

  @@indentation = 4

  # instantiate a ContinuatinoSheet object with the ADDITIONAL claimants and defendants
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
      @claimants.each do |claimant| 
        str += claimant.numbered_claimant_header
        str += claimant.indented_details(@@indentation)
        str += "\n\n"
      end
    end

    if any_defendants?
      str += defendants_header
      @defendants.each do |defendant|
        str += defendant.numbered_defendant_header
        str += defendant.indented_details(@@indentation)
        str += "\n\n"
      end
    end
    str
  end



  private

  def claimants_header
    "Additional Claimants\n====================\n\n\n"
  end


  def defendants_header
    "Additional Defendants\n=====================\n\n\n"
  end


end