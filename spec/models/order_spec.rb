require 'spec_helper'

describe Order do
  let(:order) { Order.new(possession: possession, cost: cost) }

  let(:possession) { 'Yes' }
  let(:cost) { 'no' }
  subject { order }

  context "when possession Yes" do
    it { should be_valid }
  end

  context "when possession no" do
    let(:possession) { 'no' }
    it { should_not be_valid }
    it 'should have error message' do
      order.valid?
      order.errors.full_messages.should == ['Possession must be checked']
    end
  end

  context "when possession blank" do
    let(:possession) { '' }
    it { should_not be_valid }
  end

  context "when cost blank" do
    let(:cost) { '' }
    it { should_not be_valid }
  end

  context "when cost no" do
    let(:cost) { 'no' }
    it { should be_valid }
  end

  describe "#as_json" do
    let(:desired_format) do
      {
        "possession" => 'Yes',
        "cost" => 'no'
      }
    end

    it "should produce formatted output" do
      expect(order.as_json).to eq desired_format
    end
  end

end
