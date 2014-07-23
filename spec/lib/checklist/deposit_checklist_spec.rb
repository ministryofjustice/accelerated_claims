# -*- coding: utf-8 -*-
describe DepositChecklist do
  describe '#add' do
    let(:json) do
      data = claim_formatted_data
      data['required_documents'] = ''
      data['deposit_received'] = 'Yes'
      data['deposit_as_money'] = 'Yes'
      data
    end
    let(:deposit) { DepositChecklist.new(json).add['required_documents'] }
    let(:text) { "- The tenancy deposit scheme certificate or insurance premium certificate - marked 'F'\n\n" }

    context 'when money deposit is given' do
      it { expect(deposit).to eq text }
    end
  end
end
