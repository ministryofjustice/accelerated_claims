describe Property, :type => :model do
  let(:property) do
    Property.new(street: "1 Aha Street\nLondon",
                 postcode: "SW1H 9AJ",
                 house: "Yes")
  end

  describe 'initialization' do
    it 'should instantiate use_live_postcode_lookup if in params as true' do
      property = Property.new(use_live_postcode_lookup: true)
      expect(property.address.use_live_postcode_lookup).to be true
    end

    it 'should instantiate use_live_postcode_lookup if in params as false' do
      property = Property.new(use_live_postcode_lookup: false)
      expect(property.address.use_live_postcode_lookup).to be false
    end

    it 'should instantiate use_live_postcode_lookup if absent from params' do
      property = Property.new()
      expect(property.address.use_live_postcode_lookup).to be false
    end
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

    it 'should accept english postcodes' do
      expect(property).to be_valid
    end

    it 'should reject scottish postcodes' do
      property = Property.new(street: "1 Aha Street\nLondon", postcode: "SW1H 5AJ", house: "Yes")
      expect(property).not_to be_valid
      expect(property.errors['postcode']).to eq [ "Postcode is in Scotland. You can only use this service to regain possession of properties in England and Wales." ]
    end

    it 'should reject invalid postcodes' do
      property = Property.new(street: "1 Aha Street\nLondon", postcode: "ABC105AB", house: "Yes")
      expect(property).not_to be_valid
      expect(property.errors['postcode']).to eq [ "Please enter a valid postcode for a property in England and Wales" ]
    end

    subject { property }

    describe "house" do
      it "when blank" do
        property.house = ""
        expect(property).not_to be_valid
      end
    end

    context 'missing postcode' do
      it 'should generate an error message' do
        property.postcode = nil
        expect(property.valid?).not_to be true
        expect(property.errors[:postcode]).to eq ['Please enter a valid postcode for a property in England and Wales']
      end
    end

    context 'invalid address' do
      it 'should generate an error message of the street is missing' do
        property.street = nil
        expect(property.valid?).not_to be true
        expect(property.errors[:street]).to eq ['Enter property full address']
      end
    end
  end
end
