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
    # include_examples 'address presence validationaddress presence validation'
    # include_examples 'address validation'

    describe "house" do
      it "when blank" do
        property.house = ""
        expect(property).not_to be_valid
      end
    end


    context 'invalid postcode' do
      it 'should generate an error message' do
        property.postcode = 'ABC4545'
        expect(property).not_to be_valid
      end
    end

    context 'missing postcode' do
      it 'should generate an error message' do
        property.postcode = nil
        expect(property.valid?).not_to be true
        expect(property.errors[:postcode]).to eq ['Enter the property postcode']
      end
    end


    context 'invalid address' do
      it 'should generate an error message of the street is missing' do
        property.street = nil
        expect(property.valid?).not_to be true
        expect(property.errors[:street]).to eq ['Enter the property address']
      end
    end
  end
end
