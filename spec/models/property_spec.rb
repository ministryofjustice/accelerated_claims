require 'spec_helper'

describe Property do
  let(:property) do
    Property.new(street: "1 Aha Street",
                 town: "London",
                 postcode: "SW1H 9AJ",
                 house: true)
  end

  describe "#as_json" do
    let(:json_output) do
      {
        "property" => "1 Aha Street, London",
        "property_postcode1" => "SW1H",
        "property_postcode2" => "9AJ"
      }
    end

    it "should produce formated output" do
      property.as_json.should eq json_output
    end
  end

  describe "validations" do
    let(:property) do
      Property.new(street: "1 Aha Street",
                   town: "London",
                   postcode: "SW1H 9AJ",
                   house: true)
    end



    describe "when given all valid values" do
      it "should be valid" do
        property.should be_valid
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

      context "when not a full postcode" do
        it "shouldn't be valid" do
          property.postcode = "SW1"
          property.should_not be_valid
        end
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
