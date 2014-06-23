describe Defendant, :type => :model do
  let(:defendant) do
    Defendant.new(title: "Mr",
                  full_name: "John Major",
                  street: "Sesame Street\nLondon",
                  postcode: "SW1X 2PT")
  end

  describe "when given all valid values" do
    it "should be valid" do
      expect(defendant).to be_valid
    end
  end

  context 'when not first_defendant' do
    before { defendant.first_defendant = false }

    subject { defendant }

    context "name fields blank" do
      before do
        defendant.title = ""
        defendant.full_name = ""
      end

      context 'and address blank' do
        before do
          defendant.street = ""
          defendant.postcode = ""
        end
        it { is_expected.to be_valid }
      end

      context 'and address present' do
        it { is_expected.not_to be_valid }
      end
    end

    context 'only title blank' do
      before { defendant.title = "" }
      it { is_expected.not_to be_valid }
      it 'has error message' do
        subject.valid?
        expect(subject.errors.full_messages).to eq(['Title must be entered'])
      end
    end

    context 'only full_name blank' do
      before { defendant.full_name = "" }
      it { is_expected.not_to be_valid }
      it 'has error message' do
        subject.valid?
        expect(subject.errors.full_messages).to eq(['Full name must be entered'])
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
