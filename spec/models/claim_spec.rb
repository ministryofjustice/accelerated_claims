require 'spec_helper'

describe Claim do
  before :each do
    @claim = Claim.new(data)
  end

  subject { @claim }

  describe 'form_state' do
    let(:data) do
      claim_post_data['claim'].merge( 'form_state' => 'some state' )
    end

    its(:form_state) { should == 'some state' }
  end

  describe '#initialize' do
    let(:data) { {} }

    it 'should have submodels' do
      %w(property claimant_one claimant_two notice license deposit
         fee possession order defendant_one defendant_two).each do |attr|
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

      it 'should set demoted tenancy boolean on tenancy' do
        @claim.tenancy.demoted_tenancy.should be_true
      end
    end

    context "when only claim fee is known" do
      let(:data) do
        hash = claim_post_data['claim']
        hash["claimant_contact"].delete("legal_costs")
        hash
      end

      it 'should return the total cost' do
        @claim.as_json.should include "total_cost"
      end

      it 'should match total fee' do
        @claim.as_json["total_cost"].should eq @claim.as_json["fee_court_fee"]
      end
    end
  end
end
