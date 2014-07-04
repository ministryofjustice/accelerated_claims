describe Defendant, :type => :model do
  let(:defendant) do
    Defendant.new(title: "Mr",
                  full_name: "John Major",
                  street: "Sesame Street\nLondon",
                  postcode: "SW1X 2PT",
                  inhabits_property: 'no')
  end

  let(:property_inhabiting_defendant) do
    Defendant.new(title: "Mr",
                  full_name: "John Major",
                  inhabits_property: 'yes')
  end



  describe "when given all valid values" do
    it "should be valid" do
      expect(defendant).to be_valid
    end
  end


  context 'validate_presence not set' do

    context 'property_address is no' do
      it 'should set the validate_presence attribute to true if missing' do
        expect(defendant.validate_presence).to be true
      end

      it 'should be valid if all attributes are set ' do
        expect(defendant.validate_presence).to be true
        expect(defendant).to be_valid
      end

      it 'should not be valid if full name is missing' do
        defendant.full_name = nil
        expect(defendant).to_not be_valid
        expect(defendant.errors.full_messages).to eq ['Full name must be entered']
      end

      it 'should not be valid if postcode is missing' do
        defendant.postcode = nil
        expect(defendant).to_not be_valid
        expect(defendant.errors.full_messages).to eq ['Postcode must be entered']
      end

      it 'should not be valid if street is missing' do
        defendant.street = nil
        expect(defendant).to_not be_valid
        expect(defendant.errors.full_messages).to eq ['Street must be entered']
      end
    end


    context 'inhabit_property is yes' do
      it 'should be valid if all attributes except street and postcode are set ' do
        expect(property_inhabiting_defendant.validate_presence).to be true
        expect(property_inhabiting_defendant.street).to be_nil
        expect(property_inhabiting_defendant.postcode).to be_nil
        expect(property_inhabiting_defendant).to be_valid
      end

      it 'should be invalid if full name is missing' do
        property_inhabiting_defendant.full_name = nil
        expect(property_inhabiting_defendant).to_not be_valid
        expect(property_inhabiting_defendant.errors.full_messages).to eq ['Full name must be entered']
      end

      it 'should be invalid if title is missing' do
        property_inhabiting_defendant.title = nil
        expect(property_inhabiting_defendant).to_not be_valid
        expect(property_inhabiting_defendant.errors.full_messages).to eq ['Title must be entered']
      end
    end
  end


  context 'validate_presence set to true' do

    context 'property_address is no' do
      
      before(:each) { defendant.validate_presence = true }

      it 'should set the validate_presence attribute to true if missing' do
        expect(defendant.validate_presence).to be true
      end

      it 'should be valid if all attributes are set ' do
        expect(defendant.validate_presence).to be true
        expect(defendant).to be_valid
      end

      it 'should not be valid if full name is missing' do
        defendant.full_name = nil
        expect(defendant).to_not be_valid
        expect(defendant.errors.full_messages).to eq ['Full name must be entered']
      end

      it 'should not be valid if postcode is missing' do
        defendant.postcode = nil
        expect(defendant).to_not be_valid
        expect(defendant.errors.full_messages).to eq ['Postcode must be entered']
      end

      it 'should not be valid if street is missing' do
        defendant.street = nil
        expect(defendant).to_not be_valid
        expect(defendant.errors.full_messages).to eq ['Street must be entered']
      end
    end


    context 'property_address is yes' do

      before(:each) { property_inhabiting_defendant.validate_presence = true }

      it 'should be valid if all attributes except street and postcode are set ' do
        expect(property_inhabiting_defendant.validate_presence).to be true
        expect(property_inhabiting_defendant.street).to be_nil
        expect(property_inhabiting_defendant.postcode).to be_nil
        expect(property_inhabiting_defendant).to be_valid
      end

      it 'should be invalid if full name is missing' do
        property_inhabiting_defendant.full_name = nil
        expect(property_inhabiting_defendant).to_not be_valid
        expect(property_inhabiting_defendant.errors.full_messages).to eq ['Full name must be entered']
      end

      it 'should be invalid if title is missing' do
        property_inhabiting_defendant.title = nil
        expect(property_inhabiting_defendant).to_not be_valid
        expect(property_inhabiting_defendant.errors.full_messages).to eq ['Title must be entered']
      end
    end
  end


  context 'validate_abscence set to true' do
    let(:nil_defendant)  { Defendant.new(:validate_presence => false, :validate_absence => true) }

    it 'should be valid if all fields are empty' do
      [:title, :full_name, :street, :postcode, :inhabits_property].each do |field|
        expect(nil_defendant.send(field)).to be_nil
      end
      expect(nil_defendant).to be_valid
    end

    it 'should be invalid if title is present' do
      nil_defendant.title = 'Mr'
      expect(nil_defendant).to_not be_valid
    end

    it 'should be invalid if full_name is present' do
      nil_defendant.full_name = 'Stephen Richards'
      expect(nil_defendant).to_not be_valid
    end

    it 'should be invalid if street is present' do
      nil_defendant.street = 'London Road'
      expect(nil_defendant).to_not be_valid
    end

    it 'should be invalid if postcode is present' do
      nil_defendant.postcode = 'SW10 9LB'
      expect(nil_defendant).to_not be_valid
    end

  end





  describe "#as_json" do
    context "when the model is not blank" do
      let(:desired_format) do
        {
          "address" => "Mr John Major\nSesame Street\nLondon",
          "postcode1" => "SW1X",
          "postcode2" => "2PT"
        }
      end
      it "should generate the correct JSON" do
        expect(defendant.as_json).to eq desired_format
      end
    end

    context "when the model is blank" do
      let(:defendant) { Defendant.new() }

      it "should generate a blank JSON" do
        expect(defendant.as_json).to eq Hash.new
      end
    end
  end

end
