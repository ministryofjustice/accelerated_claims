describe Property, :type => :model do
  let(:property) do
    Property.new(street: "1 Aha Street\nLondon",
                 postcode: "SW1H 9AJ",
                 house: "Yes")
  end

  describe "#as_json" do
    let(:json_output) do
      {
        "address" => "1 Aha Street\nLondon",
        "postcode1" => "SW1H",
        "postcode2" => "9AJ",
        "house" => "Yes"
      }
    end

    it "should produce formated output" do
      expect(property.as_json).to eq json_output
    end
  end

  describe "validations" do
    let(:property) do
      Property.new(street: "1 Aha Street\nLondon",
                   postcode: "SW1H 9AJ",
                   house: "Yes")
    end



    describe "when given all valid values" do
      it "should be valid" do
        expect(property).to be_valid
      end
    end

    subject { property }
    include_examples 'address presence validation'
    include_examples 'address validation'

    describe "house" do
      it "when blank" do
        property.house = ""
        expect(property).not_to be_valid
      end
    end
  end
end
