describe Claimant do
  let(:claimant) do
    Claimant.new(title: 'Mr',
                 full_name: "John Doe",
                 street: "Streety Street\nLondon",
                 postcode: "SW1H9AJ")
  end

  subject { claimant }

  it { should be_valid }

  context 'when validate_presence false' do
    before { claimant.validate_presence = false }

    context "when full_name is blank" do
      before { claimant.full_name = "" }
      it { should be_valid }
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
