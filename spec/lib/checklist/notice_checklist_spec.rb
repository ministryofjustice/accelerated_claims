describe NoticeChecklist do
  describe '#add' do
    let(:json) do
      data = claim_formatted_data
      data['required_documents'] = ''
      data
    end
    let(:text) { "- the notice you gave to the defendant to leave the property - marked 'C'\n\n- proof the notice was served - marked 'C1'\n\n" }
    let(:notice) { NoticeChecklist.new(json).add['required_documents'] }

    it { expect(notice).to eq text }
  end
end
