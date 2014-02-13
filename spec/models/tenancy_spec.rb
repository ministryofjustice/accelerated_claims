require 'spec_helper'

describe Tenancy do
  let(:tenancy) do
    Tenancy.new(start_date: "01 01 2010",
               latest_agreement_date: "01 01 2010",
               agreement_reissued_for_same_property: false,
               agreement_reissued_for_same_landlord_and_tenant: false)
  end

  describe "when given all valid values" do
    it "should be valid" do
      tenancy.should be_valid
    end
  end

  describe "agreement_reissued_for_same_property" do
    it "when blank" do
      tenancy.agreement_reissued_for_same_property = ""
      tenancy.should_not be_valid
    end
  end

  describe "#as_json" do
    let(:desired_format) do
      {
        "start_date" => "01 01 2010",
        "latest_agreement_date" => "01 01 2010",
        "agreement_reissued_for_same_property" => false,
        "agreement_reissued_for_same_landlord_and_tenant" => false
      }
    end

    it "should generate the correct JSON" do
      tenancy.as_json.should eq desired_format
    end
  end
end
