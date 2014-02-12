require 'spec_helper'

describe Landlord do
  let(:landlord) do
    Landlord.new(company: "Landlord LTD",
                 street: "Streety Street",
                 town: "London",
                 postcode: "SW1H9AJ")
  end

  describe "when given all valid values" do
    it "should be valid" do
      landlord.should be_valid
    end
  end

  describe "company name" do
    it "when blank" do
      landlord.company = ""
      landlord.should_not be_valid
    end

    it "when over 40 characters" do
      landlord.street = "x" * 41
      landlord.should_not be_valid
    end
  end

  describe "#as_json" do
    let(:json_output) do
      {
        "address" => "Landlord LTD\nStreety Street\nLondon",
        "postcode1" => "SW1H",
        "postcode2" => "9AJ"
      }
    end

    it "should produce formated output" do
      landlord.as_json.should eq json_output
    end
  end

end
