# -*- coding: utf-8 -*-
describe TenancyChecklist do

  describe '#add' do
    before(:each) { @documents = TenancyChecklist.new(json).add['required_documents'] }

    describe 'Assured shorthold tenancy' do
      context 'when there is only 1 tenancy agreement' do
        let(:text) { "- the tenancy agreement marked 'A'\n\n" }

        context 'optional section is filled' do
          let(:json) { claim_formatted_data }

          let(:full_text) { text.concat "- the notice stating defendants would have an assured shorthold tenancy agreement (given before they moved in) - marked 'B'
- proof this notice was given - marked 'B1'\n\n"}

          it { expect(@documents.should).to eq full_text }
        end

        context 'optional section is not filled' do
          let(:json) do
            data = claim_formatted_data
            data['tenancy_assured_shorthold_tenancy_notice_served_by'] = ''
            data['tenancy_assured_shorthold_tenancy_notice_served_date_day'] = ''
            data['tenancy_assured_shorthold_tenancy_notice_served_date_month'] = ''
            data['tenancy_assured_shorthold_tenancy_notice_served_date_year'] = ''
            data
          end

          it { expect(@documents.should).to eq text }
        end
      end

      context 'when there is more than 1 tenancy agreements' do
        let(:text) { "- the first tenancy agreement marked - 'A'\n\n- the current tenancy agreement marked - 'A1'\n\n"}
        let(:json) do
          claim_formatted_data.merge({ 'tenancy_previous_tenancy_type' => 'assured',
                                       'tenancy_assured_shorthold_tenancy_type' => 'multiple' })
        end

        context 'optional section is filled' do
          let(:full_text) { text.concat "- the notice stating defendants would have an assured shorthold tenancy agreement (given before they moved in) - marked 'B'
- proof this notice was given - marked 'B1'\n\n"}

          it { expect(@documents.should).to eq full_text }
        end

        context 'optional section is not filled' do
          let(:json) do
            claim_formatted_data.merge({ 'tenancy_previous_tenancy_type' => 'assured',
                                         'tenancy_assured_shorthold_tenancy_type' => 'multiple',
                                         'tenancy_assured_shorthold_tenancy_notice_served_by' => '',
                                         'tenancy_assured_shorthold_tenancy_notice_served_date_day' => '',
                                         'tenancy_assured_shorthold_tenancy_notice_served_date_month' => '',
                                         'tenancy_assured_shorthold_tenancy_notice_served_date_year' => '' })
          end
          let(:text) { "- the first tenancy agreement marked - 'A'\n\n- the current tenancy agreement marked - 'A1'\n\n" }

          it { expect(@documents.should).to eq text }
        end

      end
    end

    describe 'Demoted assured shorthold tenancy' do
      let(:json) do
        data = claim_formatted_data
        data['tenancy_demoted_tenancy'] = 'Yes'
        data
      end
      let(:text) { "- the most recent tenancy agreement - marked 'A'\n\n- the demotion order - marked 'B'\n\n" }

      it 'should have the appropriate text' do
        @documents.should eq text
      end
    end
  end
end
