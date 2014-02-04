class ClaimController < ApplicationController
  def new
  end

  def claim_submission
    redirect_to thank_you_path
  end

  def thank_you
  end
end
