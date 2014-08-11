describe ClaimantCollection do

  let(:cc)        { ClaimantCollection.new(3, claim_params) }

  describe '.new' do
    it 'should instantiate a collection with the correct number of claimants' do
      # cc = ClaimantCollection.new(3, claim_params)
      expect(cc).to be_instance_of ClaimantCollection
      expect(cc.size).to eq 3
    end

    it 'should fail if the number of claimants in the params is less than the number given in the initializer' do
      expect {
        ClaimantCollection.new(4, claim_params)
      }.to raise_error ArgumentError, 'Unable to find claimant_4 in the params'
    end
  end


  describe '#[]' do
    it 'should return the claimant of the given index' do
      claimant = cc[2]
      expect(claimant).to be_instance_of(Claimant)
      expect(claimant.full_name).to eq "John Smith 2nd"
    end

    it 'should raise error if index 0 is given' do
      expect {
        cc[0]
      }.to raise_error ArgumentError, "No such index: 0"
    end
  

    it 'should raise error if the index is higher than the number of claimants' do
      expect {
          cc[4]
        }.to raise_error ArgumentError, "No such index: 4"
    end
  end


  describe '#[]=' do

    let(:claimant)   { Claimant.new( { "title" => "Mrs", "full_name" => "Maggie Thatcher", "street" => "10 Downing Street St\nLondon", "postcode" => "SW1W 0LU"} ) }
    it 'should raise error if index is zero' do
      expect {
        cc[0] = claimant
      }.to raise_error ArgumentError, "Invalid index: 0"
    end

    it 'should raise error if index is greater than number of claimants' do
      expect {
        cc[4] = claimant
      }.to raise_error ArgumentError, "Invalid index: 4"
    end

    it 'should replace the specified claimant with the new claimant' do
      cc[3] = claimant
      c = cc[3]
      expect(c.full_name).to eq 'Maggie Thatcher'
    end
  end

end




def claim_params
  HashWithIndifferentAccess.new(
    { "claim" =>
      { "num_claimants" => 3,
        "claimant_type" => 'individual',
        "claimant_1" =>
        {
          "title" => "Mr",
          "full_name" => "John Smith 1st",
          "street" => "2 Brown St\nCwmbran",
          "postcode" => "SW1W 0LU"
        },
        "claimant_2" =>
        {
          "title" => "Mr",
          "full_name" => "John Smith 2nd",
          "street" => "2 Brown St\nCwmbran",
          "postcode" => "SW1W 0LU"
        },
        "claimant_3" =>
        {
          "title" => "Mr",
          "full_name" => "John Smith 3rd",
          "street" => "2 Brown St\nCwmbran",
          "postcode" => "SW1W 0LU"
        }
      }
    }
  )
end

