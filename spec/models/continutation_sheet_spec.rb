describe ContinuationSheet do

  let(:mock_claimant) {
    double Claimant
  }

  let(:mock_defendant) {
    double Defendant
  }


  let(:claimant_3) {
    params = HashWithIndifferentAccess.new(title: 'Mr', full_name: "John Doe", street: "Streety Street\nLondon", postcode: "SW1H9AJ",  claimant_type: 'individual', claimant_num: 1) 
    Claimant.new(params)
  }

  let(:claimant_4) {
    params = HashWithIndifferentAccess.new(title: 'Mr', full_name: "Jane Doe", street: "Flat 5\nMansion House\nStreety Street\nKensington\nLondon", postcode: "SW1H9AJ",  claimant_type: 'individual', claimant_num: 1) 
    Claimant.new(params)
  }

  describe '#empty?' do
    it 'should respond true if instantiated with two empty arrays' do
      cs = ContinuationSheet.new(Array.new, Array.new)
      expect(cs.empty?).to be true
    end

    it 'should respond false if the first array is not empty' do
      cs = ContinuationSheet.new([mock_claimant], Array.new)
      expect(cs.empty?).to be false
    end

    it 'should respend false if the second array is not empty' do
      cs = ContinuationSheet.new(Array.new, [ mock_defendant] )
      expect(cs.empty?).to be false
    end

    it 'should repsond false if both arrays are not empty' do
       cs = ContinuationSheet.new([mock_claimant], [ mock_defendant] )
      expect(cs.empty?).to be false     
    end
  end



  describe '#any_defendants?' do
    it 'should return true if there are any defendants' do
      cs = ContinuationSheet.new(Array.new, [ mock_defendant] )
      expect(cs.any_defendants?).to be true
    end

    it 'should return flase if there are no defendants' do
      cs = ContinuationSheet.new([mock_claimant], Array.new)
      expect(cs.any_defendants?).to be false
    end
  end


  describe '#any_claimants?' do
    it 'should return true if there are any defendants' do
      cs = ContinuationSheet.new([mock_claimant], Array.new )
      expect(cs.any_claimants?).to be true
    end

    it 'should return flase if there are no defendants' do
      cs = ContinuationSheet.new(Array.new, [ mock_defendant])
      expect(cs.any_claimants?).to be false
    end
  end


  describe '#left_side' do
    context 'claimants only' do
      it 'should produce a header and just the claimant when only one claimant' do
        cs = ContinuationSheet.new( [claimant_3], Array.new )
        expect(cs.left_side).to eq one_claimant_expected_results
      end
    end
  end

end



def one_claimant_expected_results
  result =<<EOS
Additional Claimants
====================

Claimant 3:
  Mr John Doe
  Streety Street
  London SW1H 9AJ
EOS
end













