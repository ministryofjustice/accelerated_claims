describe Defendant do
  let(:defendant) do
    Defendant.new(title: "Mr",
                  full_name: "John Major",
                  street: "Sesame Street\nLondon",
                  postcode: "SW1X 2PT")
  end

  describe "when given all valid values" do
    it "should be valid" do
      defendant.should be_valid
    end
  end

  context 'when validate_presence false' do
    before { defendant.validate_presence = false }

    subject { defendant }

    describe "full_name name" do
      it "when blank should be valid" do
        defendant.full_name = ""
        defendant.should be_valid
      end
    end

    include_examples 'address validation'
  end

  context 'when validate_presence true' do
    before { defendant.validate_presence = true }

    subject { defendant }

    include_examples 'name validation'
    include_examples 'address validation'
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
        defendant.as_json.should eq desired_format
      end
    end

    context "when the model is blank" do
      let(:defendant) { Defendant.new() }

      it "should generate a blank JSON" do
        defendant.as_json.should eq Hash.new
      end
    end
  end

end
