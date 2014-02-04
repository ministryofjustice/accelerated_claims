require 'spec_helper'

describe Landlord do
  let(:landlord) { Landlord.new }

  describe "when given all valid values" do
    it "should be valid" do
      Landlord.new(company: "Landlord LTD",
                   street: "Streety Street",
                   town: "London",
                   postcode: "SW1").should be_valid
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
end
