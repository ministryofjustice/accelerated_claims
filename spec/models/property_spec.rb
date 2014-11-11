describe Property, :type => :model do
  let(:property) do
    Property.new(street: "1 Aha Street\nLondon",
                 postcode: "SW1H 9AJ",
                 house: "Yes")
  end


  describe 'initialization' do
    it 'should instantiate livepc if in params as true' do
      property = Property.new(HashWithIndifferentAccess.new(street: 'xxxx', postcode: 'RG2 7PU', house: 'Yes', livepc: true))
      expect(property.livepc).to be true
    end

    it 'should instantiate livepc if in params as false' do
      property = Property.new(HashWithIndifferentAccess.new(street: 'xxxx', postcode: 'RG2 7PU', house: 'Yes', livepc: false))
      expect(property.livepc).to be false
    end

    it 'should instantiate livepc if absent from params' do
      property = Property.new(HashWithIndifferentAccess.new(street: 'xxxx', postcode: 'RG2 7PU', house: 'Yes'))
      expect(property.livepc).to be false
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
      property.postcode = 'AB10 5AB'
      expect(property).not_to be_valid
      expect(property.errors['postcode']).to eq [ "Postcode is in Scotland. You can only use this service to regain possession of properties in England and Wales." ]
    end

    it 'should reject invalid postcodes'

    subject { property }

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
