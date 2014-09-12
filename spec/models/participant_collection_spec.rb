describe ClaimantCollection do

  describe '.new' do
    it 'should raise an exception' do
      expect {
        ParticipantCollection.new( {} )
      }.to raise_error RuntimeError, 'Cannot instantiate Participant Collection: instantiate a subclass instead'
    end
  end
end
