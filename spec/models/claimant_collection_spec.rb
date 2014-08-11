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

    it 'should return size of one with 1 empty claimant if instantiated with empty params' do
      cc2 = ClaimantCollection.new(1, {})
      expect(cc2.size).to eq 1
      expect(cc2[1]).to eq Claimant.new
    end

    it 'should insert claimant with validate absence = true if more thatn the num_claimants' do
      claim_params['num_claimants'] = 2
      cc2 = ClaimantCollection.new(2, claim_params)
      valid_claimant = cc2[1]
      expect(valid_claimant.validate_absence?).to be false
      expect(valid_claimant.valid?).to be true
      invalid_claimant = cc2[3]
      expect(invalid_claimant.validate_absence?).to be true
      expect(invalid_claimant.valid?).to be false
      expect(cc2.size).to eq 2
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
  

    it 'should return nil if the index is higher than the number of claimants' do
      expect(cc[4]).to be_nil
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


  describe 'model_hash' do
    it 'should produce the hash with the correct number of claimants' do
      expect(cc.model_hash).to eq({ 'claimant_1' => 'Claimant', 'claimant_2' => 'Claimant', 'claimant_3' => 'Claimant' })
    end
  end

  describe 'as_json' do
    it 'should produce a json representation of the contacts' do
      expect(cc.as_json).to eq expected_json(cc)
    end

  end

end


def expected_json(cc)
  {'claimant_1' => cc[1].as_json, 'claimant_2' => cc[2].as_json, 'claimant_3' => cc[3].as_json }.as_json
end



def claim_params
  HashWithIndifferentAccess.new(
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
  )
end

