require 'spec_helper'

describe Claimant do
  let(:claimant) do
    Claimant.new(title: 'Mr',
                 full_name: "John Doe",
                 street: "Streety Street\nLondon",
                 postcode: "SW1H9AJ")
  end

  describe "when given all valid values" do
    it "should be valid" do
      claimant.should be_valid
    end
  end

  context 'when validate_presence false' do
    before do
      claimant.validate_presence = false
    end

    subject { claimant }

    describe "full_name name" do
      it "when blank should be valid" do
        claimant.full_name = ""
        claimant.should be_valid
      end
    end

    include_examples 'address validation'
  end

  context 'when validate_presence true' do
    before do
      claimant.validate_presence = true
    end

    subject { claimant }

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

    it "should produce formated output" do
      claimant.as_json.should eq json_output
    end
  end

end
