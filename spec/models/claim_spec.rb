require 'spec_helper'

describe Claim do
  before :each do
    @claim = Claim.new(data)
  end

  describe '#initialize' do
    let(:data) { {} }

    it 'should have submodels' do
      %w(property claimant_one claimant_two notice license deposit
         possession order defendant_one defendant_two).each do |attr|
        expect(@claim).to respond_to attr
      end
    end
  end

  describe '#as_json' do
    context "when both claim fee & legal cost are known" do
      let(:data) { claim_post_data['claim'] }
      let(:desired_format) { claim_formatted_data }

      it 'should return the right JSON' do
        expect(@claim.as_json).to eql desired_format
      end
    end

    context "when only claim fee is known" do
      let(:data) do
        hash = claim_post_data['claim']
        hash["claimant_contact"].delete("legal_costs")
        hash
      end

      it 'should not return the total cost' do
        @claim.as_json.should_not include "total_cost"
      end
    end
  end
end
