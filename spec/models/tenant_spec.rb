require 'spec_helper'

describe Tenant do
  let(:tenant) do
    Tenant.new(title: "Mr",
               full_name: "John Major",
               street: "Sesame Street",
               town: "London",
               postcode: "SW1X 2PT")
  end

  describe "when given all valid values" do
    it "should be valid" do
      tenant.should be_valid
    end
  end

  describe "title" do
    it "when blank" do
      tenant.title = ""
      tenant.should_not be_valid
    end

    it "when over 8 characters long" do
      tenant.title = "x" * 9
      tenant.should_not be_valid
    end
  end

  describe "#as_json" do
    let(:desired_format) do
      {
        "address" => "Mr John Major\nSesame Street\nLondon",
        "postcode1" => "SW1X",
        "postcode2" => "2PT"
      }
    end

    it "should generate the correct JSON" do
      tenant.as_json.should eq desired_format
    end
  end
end
