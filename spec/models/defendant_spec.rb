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

  context 'when first_defendant false' do
    before { defendant.first_defendant = false }

    subject { defendant }

    context "name fields blank" do
      before do
        defendant.title = ""
        defendant.full_name = ""
      end
      it { should be_valid }
    end

    context 'only title blank' do
      before { defendant.title = "" }
      it { should_not be_valid }
      it 'has error message' do
        subject.valid?
        subject.errors.full_messages.should == ['Title must be entered']
      end
    end

    context 'only full_name blank' do
      before { defendant.full_name = "" }
      it { should_not be_valid }
      it 'has error message' do
        subject.valid?
        subject.errors.full_messages.should == ['Full name must be entered']
      end
    end

    include_examples 'address validation'
  end

  context 'when first_defendant true' do
    before { defendant.first_defendant = true }

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
