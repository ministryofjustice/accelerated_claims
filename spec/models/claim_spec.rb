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

    context "when it isn't a demoted tenancy" do
      let(:data) do
        claim = claim_post_data['claim']
        claim["demoted_tenancy"]["demoted_tenancy"] = 'No'
        claim
      end

      let(:desired_format) do
        format = claim_formatted_data
        format["demoted_tenancy_demoted_tenancy"] = 'No'
        format["tenancy_agreement_reissued_for_same_property"] = 'NA'
        format["tenancy_agreement_reissued_for_same_landlord_and_tenant"] = 'NA'
        format
      end

      context "and it's the only tenancy" do
        it 'should return the right JSON' do
          expect(@claim.as_json).to eql desired_format
        end
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

    context "when a defendant's address is blank" do
      let(:data) do
        hash = claim_post_data['claim']
        hash['defendant_one'] = hash['defendant_one'].except('street', 'town', 'postcode')
        hash['defendant_two'] = hash['defendant_two'].except('street', 'town', 'postcode')
        hash
      end
      it "dependant one should render with the property's address" do
        expect(@claim.as_json['defendant_one_address']).to include @claim.as_json['property_address']
        expect(@claim.as_json['defendant_one_postcode1']).to eql @claim.as_json['property_postcode1']
        expect(@claim.as_json['defendant_one_postcode2']).to eql @claim.as_json['property_postcode2']
      end
      it "defendant two should render with the property's address" do
        expect(@claim.as_json['defendant_two_address']).to include @claim.as_json['property_address']
        expect(@claim.as_json['defendant_one_postcode1']).to eql @claim.as_json['property_postcode1']
        expect(@claim.as_json['defendant_one_postcode2']).to eql @claim.as_json['property_postcode2']
      end
    end
  end
end