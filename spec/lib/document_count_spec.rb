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
        hash.delete('defendant_2_address')
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

    context 'when there are 3 claimants and 8 defendants' do
      let(:json) do
        hash = claim_formatted_data
        hash['claimant_2_address'] = hash['claimant_1_address']
        hash['claimant_3_address'] = hash['claimant_1_address']
        hash['defendant_2_address'] = hash['defendant_1_address']
        hash['defendant_3_address'] = hash['defendant_1_address']
        hash['defendant_4_address'] = hash['defendant_1_address']
        hash['defendant_5_address'] = hash['defendant_1_address']
        hash
      end
      it 'should produce 1 copy for the court and 1 for each claimant and defendant' do
        count = DocumentCount.new(json).add
        expect(count['copy_number']).to eq (1 + 3 + 5)
      end
    end

    context 'when there is 1 claimant and 1 defendant' do
      let(:json) do
        hash = claim_formatted_data
        hash.delete('defendant_2_address')
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
