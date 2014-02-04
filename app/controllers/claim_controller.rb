class ClaimController < ApplicationController
  def new
    @claim = Claim.new
    @property = Property.new
  end

  def submission
    redirect_to thank_you_path
  end

  def thank_you
  end
end
