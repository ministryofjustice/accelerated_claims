describe Order, :type => :model do
  let(:order) { Order.new(possession: possession, cost: cost) }

  let(:possession) { 'Yes' }
  let(:cost) { 'No' }
  subject { order }

  context "when possession Yes" do
    it { is_expected.to be_valid }
  end

  context "when possession no" do
    let(:possession) { 'No' }
    it { is_expected.not_to be_valid }
    it 'should have error message' do
      order.valid?
      expect(order.errors.full_messages).to eq(['Possession must be checked'])
    end
  end

  context "when possession blank" do
    let(:possession) { '' }
    it { is_expected.not_to be_valid }
  end

  context "when cost blank" do
    let(:cost) { '' }
    it { is_expected.not_to be_valid }
  end

  context "when cost no" do
    let(:cost) { 'No' }
    it { is_expected.to be_valid }
  end

  describe "#as_json" do
    let(:desired_format) do
      {
        "possession" => 'Yes',
        "cost" => 'No'
      }
    end

    it "should produce formatted output" do
      expect(order.as_json).to eq desired_format
    end
  end

end
