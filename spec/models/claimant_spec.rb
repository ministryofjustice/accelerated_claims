describe Claimant, :type => :model do
  let(:claimant) do
    Claimant.new(title: 'Mr',
                 full_name: "John Doe",
                 street: "Streety Street\nLondon",
                 postcode: "SW1H9AJ")
  end

  subject { claimant }

  it { is_expected.to be_valid }

  context 'when validate_presence false' do
    before { claimant.validate_presence = false }

    context "and full_name is blank but other fields present" do
      before { claimant.full_name = "" }
      it { is_expected.not_to be_valid }
    end

    context "and all fields blank" do
      subject { Claimant.new(title: '', full_name: '', street: '', postcode: '') }
      it { is_expected.to be_valid }
    end

    include_examples 'address validation'
  end

  context 'when validate_presence true' do
    before { claimant.validate_presence = true }

    include_examples 'name validation'
    include_examples 'address validation'
    include_examples 'address presence validation'
  end

  describe "#as_json" do
    let(:json_output) do
      {
        "address" => "Mr John Doe\nStreety Street\nLondon",
        "postcode1" => "SW1H",
        "postcode2" => "9AJ"
      }
    end

    its(:as_json) { should == json_output }
  end

end
