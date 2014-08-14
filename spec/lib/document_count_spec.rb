describe DocumentCount do

  describe '#add' do
    context 'when there are 2 defendant and 2 claimants' do
      let(:json) { claim_formatted_data }
      let(:count) { DocumentCount.new(json).add }

      it 'should add the number of documents to JSON' do
        expect(count["copy_number"]).to eq 5
      end
    end

    context 'when there are 2 defendant and 3 claimants' do
      let(:json) { claim_with_3_claimants_formatted_data }
      let(:count) { DocumentCount.new(json).add }

      it 'should add the number of documents to JSON' do
        expect(count["copy_number"]).to eq 6
      end
    end

    context 'when there are 2 defendant and 4 claimants' do
      let(:json) { claim_with_4_claimants_formatted_data }
      let(:count) { DocumentCount.new(json).add }

      it 'should add the number of documents to JSON' do
        expect(count["copy_number"]).to eq 7
      end
    end



    context 'when there are 2 claimants and 1 defendant' do
      let(:json) do
        hash = claim_formatted_data
        hash.delete('defendant_two_address')
        hash
      end
      let(:count) { DocumentCount.new(json).add }

      it 'should add the number of documents to JSON' do
        expect(count["copy_number"]).to eq 4
      end
    end

    context 'when there is 1 claimant and 2 defendants' do
      let(:json) do
        hash = claim_formatted_data
        hash.delete('claimant_2_address')
        hash
      end
      let(:count) { DocumentCount.new(json).add }

      it 'should add the number of documents to JSON' do
        expect(count["copy_number"]).to eq 4
      end
    end

    context 'when there is 1 claimant and 1 defendant' do
      let(:json) do
        hash = claim_formatted_data
        hash.delete('defendant_two_address')
        hash.delete('claimant_2_address')
        hash
      end
      let(:count) { DocumentCount.new(json).add }

      it 'should add the number of documents to JSON' do
        expect(count["copy_number"]).to eq 3
      end
    end
  end
end
