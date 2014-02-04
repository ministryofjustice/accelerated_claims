require 'spec_helper'

describe DemotedTenancy do
    let(:demoted_tenancy) {
      DemotedTenancy.new(assured: true, demotion_order_date: "1,1,2014", county_court: "Ninja")
    }

  describe "when given all valid values" do
    it "should be valid" do
     demoted_tenancy.should be_valid
    end
  end

  describe "previous tenancy" do
    it "should not be blank" do
      demoted_tenancy.assured = ""
      demoted_tenancy.should_not be_valid
    end

    it "should be boolean" do
      demoted_tenancy.assured = true
      demoted_tenancy.should be_valid
    end
  end

  describe "demotion order" do
    it "should not be blank" do
      demoted_tenancy.demotion_order_date = ""
      demoted_tenancy.should_not be_valid
    end
  end

  describe "county court" do
    it "should not be blank" do
      demoted_tenancy.county_court = ""
      demoted_tenancy.should_not be_valid
    end

    it "should be under 60 characters" do
      demoted_tenancy.county_court = "x" * 61
      demoted_tenancy.should_not be_valid
    end
  end

end
