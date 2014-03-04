require 'spec_helper'

describe DemotedTenancy do
  let(:demoted_tenancy) do
    DemotedTenancy.new(demoted_tenancy: 'Yes',
                demotion_order_date: Date.parse("2010-01-01"),
                demotion_order_court: 'Brighton County Court')
  end

  let(:desired_format) do
    {
      "demoted_tenancy" => 'Yes',
      "demotion_order_date_day" => "01",
      "demotion_order_date_month" => "01",
      "demotion_order_date_year" => "2010",
      "demotion_order_court" => 'Brighton County Court'
    }
  end

  describe "when given all valid values" do
    it "should be valid" do
      demoted_tenancy.should be_valid
    end
  end

  describe "#as_json" do
    it "should generate the correct JSON" do
      demoted_tenancy.as_json.should eq desired_format
    end
  end

end
