require 'spec_helper'

describe Claim do
  before :each do
    @claim = Claim.new(data)
  end

  describe '#initialize' do
    let(:data) { {} }

    it 'should have submodels' do
      %w(property landlord_one landlord_two notice license deposit possession order tenant_one tenant_two).each do |attr|
        expect(@claim).to respond_to attr
      end
    end
  end

  describe '#as_json' do
    let(:data) { claim_post_data['claim'] }
    let(:desired_format) { claim_formatted_data }

    it 'should return the right JSON' do
      expect(@claim.as_json).to eql desired_format
    end
  end
end
