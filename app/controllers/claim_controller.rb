class ClaimController < ApplicationController
  def new
    @claim = Claim.new
    @property = Property.new
    @landlord = Landlord.new
  end

  def submission
    redirect_to thank_you_path
  end

  def thank_you
  end
end
