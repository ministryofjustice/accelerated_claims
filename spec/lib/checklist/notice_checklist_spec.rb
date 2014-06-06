describe NoticeChecklist do
  describe '#add' do
    let(:json) do
      data = claim_formatted_data
      data['required_documents'] = ''
      data
    end
    let(:text) { "- the section 21 notice that you gave to the defendant - marked 'C'
- proof this notice was given - marked 'C1'\n\n" }
    let(:notice) { NoticeChecklist.new(json).add['required_documents'] }

    it { expect(notice).to eq text }
  end
end
