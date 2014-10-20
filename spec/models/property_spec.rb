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
        expect(property.errors[:postcode]).to eq ['Enter the postcode']
      end
    end


    context 'invalid address' do
      it 'should generate an error message of the street is missing' do
        property.street = nil
        expect(property.valid?).not_to be true
        expect(property.errors[:street]).to eq ['Enter the full address']
      end
    end

    context 'no address or postcode' do
      let(:property_with_no_address) { Property.new(:house => 'Yes') }
      
      it 'should return true for address_blank?' do
        expect(property_with_no_address).not_to be_valid
        expect(property_with_no_address.address_blank?).to be true
      end

      it 'should have an error for postcode picker' do
        expect(property_with_no_address).not_to be_valid
        expect(property_with_no_address.errors[:postcode_picker]).to eq ['Enter a postcode and select an address or manually enter the address']
      end

      it 'should not have errors for street or postcode' do
        expect(property_with_no_address).not_to be_valid
        expect(property_with_no_address.errors[:street]).to be_empty
        expect(property_with_no_address.errors[:postcode]).to be_empty
      end
    end
  end
end
