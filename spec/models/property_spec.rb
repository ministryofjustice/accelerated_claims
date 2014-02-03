require 'spec_helper'

describe Property do
  describe "relationship" do
    subject { Property.new }

    it "should belong a claim" do
      should respond_to :claim
    end
  end

  describe "validations" do
    let(:property) { Property.new }

    describe "when given all valid values" do
      it "should be valid" do
        Property.new(street: "1 Aha Street",
                     town: "London",
                     postcode: "SW1",
                     house: true).should be_valid
      end
    end

    describe "street" do
      it "when blank" do
        property.street = ""
        property.should_not be_valid
      end

      it "when over 70 characters" do
        property.street = "x" * 71
        property.should_not be_valid
      end
    end

    describe "town" do
      it "when over 40 characters" do
        property.town = "x" * 41
        property.should_not be_valid
      end
    end

    describe "postcode" do
      it "when blank" do
        property.postcode = ""
        property.should_not be_valid
      end

      it "when over 8 characters" do
        property.postcode = "x" * 9
        property.should_not be_valid
      end
    end

    describe "house" do
      it "when blank" do
        property.house = ""
        property.should_not be_valid
      end
    end
  end
end
