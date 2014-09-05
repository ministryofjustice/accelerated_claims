describe ContinuationSheet do

  let(:mock_claimant) {
    double Claimant
  }

  let(:mock_defendant) {
    double Defendant
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

end