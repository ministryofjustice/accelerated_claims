class ClaimController < ApplicationController
  def new
    @claim = Claim.new
    @property = Property.new
    @landlord = Landlord.new
    @tenant_one = Tenant.new
    @tenant_two = Tenant.new
    @demoted_tenancy = DemotedTenancy.new
    @notice = Notice.new
    @defendant = Defendant.new
    @order = Order.new
  end

  def submission
    puts params
    redirect_to thank_you_path
  end

  def thank_you
  end
end
