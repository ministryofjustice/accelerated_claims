# -*- coding: utf-8 -*-
describe Checklist do

  describe '#add' do
    describe 'Assured shorthold tenancy' do
      context 'when there is only 1 tenancy agreement' do
        let(:json) { claim_formatted_data }
        let(:text) { "• the tenancy agreement marked 'A'\n"}

        it 'should have the appropriate text' do
          Checklist.new(json).add.should eq text
        end
      end

      context 'when there are more than 1 tenancy agreements' do
        let(:json) do
          data = claim_formatted_data
          data['tenancy_previous_tenancy_type'] = 'assured'
          data
        end

        let(:text) { "• the first tenancy agreement marked - 'A'\n• the current tenancy agreement marked - 'A1'\n"}

        it 'should have the appropriate text' do
          Checklist.new(json).add.should eq text
        end
      end
    end

    describe 'Demoted assured shorthold tenancy' do
      let(:json) do
        data = claim_formatted_data
        data['tenancy_demoted_tenancy'] = 'Yes'
        data
      end

      let(:text) { "• the most recent tenancy agreement - marked 'A'\n• the demotion order - marked 'B'" }

      it 'should have the appropriate text' do
        Checklist.new(json).add.should eq text
      end
    end
  end
end
