require 'spec_helper'

describe Fee do
  let(:fee) { Fee.new(court_fee: "175.00") }

  describe "when the court fee value is blank" do
    it "shouldn't be valid" do
      fee.court_fee = ""
      fee.should_not be_valid
    end
  end

  describe "#as_json" do
    let(:desired_format) { { "court_fee" => "175.00" } }

    it "should generate the correct JSON" do
      expect(fee.as_json).to eq desired_format
    end
  end

end
