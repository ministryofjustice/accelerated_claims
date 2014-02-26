require 'spec_helper'

describe Tenancy do
  let(:tenancy) do
    Tenancy.new(start_date: Date.parse("2010-01-01"),
                latest_agreement_date: Date.parse("2010-01-01"),
                reissued_for_same_property: 'No',
                reissued_for_same_landlord_and_tenant: 'No')
  end

  describe "when given all valid values" do
    it "should be valid" do
      tenancy.should be_valid
    end
  end

  describe "agreement_reissued_for_same_property" do
    it "when blank" do
      tenancy.reissued_for_same_property = ""
      tenancy.should_not be_valid
    end
  end

  describe "#as_json" do
    let(:desired_format) do
      {
        "start_date_day" => "01",
        "start_date_month" => "01",
        "start_date_year" => "2010",
        "latest_agreement_date_day" => "01",
        "latest_agreement_date_month" => "01",
        "latest_agreement_date_year" => "2010",
        "agreement_reissued_for_same_property" => 'No',
        "agreement_reissued_for_same_landlord_and_tenant" => 'No'
      }
    end

    it "should generate the correct JSON" do
      tenancy.as_json.should eq desired_format
    end
  end
end
