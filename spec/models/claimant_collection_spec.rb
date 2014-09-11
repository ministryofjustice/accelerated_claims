describe ClaimantCollection do

  let(:claimants)        { ClaimantCollection.new(test_claim_params) }

  describe '.new' do
    it 'should instantiate a collection with the correct number of claimants' do
      expect(claimants).to be_instance_of ClaimantCollection
      expect(claimants.size).to eq 3
    end

    it 'first claimant has first_claimant set true' do
      expect(claimants[1].first_claimant).to eq true
    end

    it 'second and third claimant has first_claimant set false' do
      expect(claimants[2].first_claimant).to eq false
      expect(claimants[3].first_claimant).to eq false
    end

    it 'should fail if the number of claimants in the params is less than the number given in the initializer' do
        params = test_claim_params
        params[:num_claimants] = 4
        claimants2 = ClaimantCollection.new(params)
        expect(claimants2).not_to be_valid
        expected_errors = [
              "Claimant 4 title Enter claimant 4's title",
              "Claimant 4 full name Enter claimant 4's full name",
              "Claimant 4 street Enter claimant 4's full address",
              "Claimant 4 postcode Enter claimant 4's postcode"
            ]
        expect(claimants2.errors.full_messages).to eq expected_errors
    end

    it 'should return size of zero with 1 empty claimant if instantiated with empty params' do
      claimants2 = ClaimantCollection.new({})
      expect(claimants2.size).to eq 0
    end

    it 'should insert claimant with validate absence = true if more than the num_claimants' do
      params = test_claim_params
      params['num_claimants'] = 2
      claimants2 = ClaimantCollection.new(params)
      valid_claimant = claimants2[1]
      expect(valid_claimant.validate_absence?).to be false
      expect(valid_claimant.valid?).to be true

      valid_claimant = claimants2[2]
      expect(valid_claimant.validate_absence?).to be false
      expect(valid_claimant.valid?).to be true


      invalid_claimant = claimants2[3]
      expect(invalid_claimant.validate_absence?).to be true
      expect(invalid_claimant.valid?).to be false
      expect(claimants2.size).to eq 2
    end

  end


  describe '#[]' do
    it 'should return the claimant of the given index' do
      claimant = claimants[2]
      expect(claimant).to be_instance_of(Claimant)
      expect(claimant.full_name).to eq "John Smith 2nd"
    end

    it 'should raise error if index 0 is given' do
      expect {
        claimants[0]
      }.to raise_error ArgumentError, "No such index: 0"
    end


    it 'should return empty claimant if the index is higher than the number of claimants' do
      claimant = claimants[4]
      expect(claimant.empty?).to be true
    end
  end


  describe '#[]=' do

    let(:claimant)   { Claimant.new( { "title" => "Mrs", "full_name" => "Maggie Thatcher", "street" => "10 Downing Street St\nLondon", "postcode" => "SW1W 0LU"} ) }
    it 'should raise error if index is zero' do
      expect {
        claimants[0] = claimant
      }.to raise_error ArgumentError, "Invalid index: 0"
    end

    it 'should raise error if index is greater than number of claimants' do
      expect {
        claimants[4] = claimant
      }.to raise_error ArgumentError, "Invalid index: 4"
    end

    it 'should replace the specified claimant with the new claimant' do
      claimants[3] = claimant
      c = claimants[3]
      expect(c.full_name).to eq 'Maggie Thatcher'
    end
  end


  describe 'as_json' do
    it 'should produce a json representation of the contacts' do
      expect(claimants.as_json).to eq expected_claimant_collected_json(claimants)
    end
  end



  context 'instantiating with an empty array' do
    it 'should intantiate a collection of 4 empty objects' do
      claimants = ClaimantCollection.new( HashWithIndifferentAccess.new )
      expect(claimants.size).to eq 0
      expect(claimants[1]).to eq Claimant.new('first_claimant' => true)
      expect(claimants[2]).to eq Claimant.new('first_claimant' => false)
      expect(claimants[3]).to eq Claimant.new('first_claimant' => false)
      expect(claimants[4]).to eq Claimant.new('first_claimant' => false)
    end
  end


  describe '.max_claimants' do
    it 'should return the maximum number of claimants' do
      expect(ClaimantCollection.max_claimants).to eq 4
    end
  end


  describe '.participant_type' do
    it 'should return claimant' do
      expect(ClaimantCollection.participant_type).to eq 'claimant'
    end
  end


  describe '#further_participants' do
    it 'should return an emtpy array if empty collection' do
      cc = ClaimantCollection.new( HashWithIndifferentAccess.new )
      expect(cc.further_participants).to be_empty
    end

    it 'should return an empty array if only one claimant' do
      params = test_claim_params
      params.delete('claimant_2')
      params.delete('claimant_3')
      params['num_claimants'] = 1
      cc2 = ClaimantCollection.new(params)
      expect(cc2.size).to eq 1
      expect(cc2.further_participants).to be_empty
    end

    it 'should return an array of just second claimant if two claimants' do
      params = test_claim_params
      params.delete('claimant_3')
      params['num_claimants'] = 2
      cc2 = ClaimantCollection.new(params)
      expect(cc2.size).to eq 2
      expect(cc2.further_participants).to be_empty
    end

    it 'should return an arry of claimant 3 if 3 claimants' do
      expect(cc.further_participants).to eq [ cc[3] ]
    end

    it 'should return an array of claimants 3, 4 if 4 claimants' do
      params = test_claim_params
      params.merge!(test_claimant_4)
      params['num_claimants'] = 4
      cc2 = ClaimantCollection.new(params)
      expect(cc2.size).to eq 4
      expect(cc2.further_participants).to eq [ cc2[3], cc2[4] ]
    end
  end



end


def expected_claimant_collected_json(claimants)
  {'claimant_1' => claimants[1].as_json, 'claimant_2' => claimants[2].as_json, 'claimant_3' => claimants[3].as_json }.as_json
end



def test_claim_params
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


def test_claimant_4
  {
    "claimant_4" =>
    {
      "title" => "Mr",
      "full_name" => "John Smith 4th",
      "street" => "2 Brown St\nCwmbran",
      "postcode" => "SW4W 4LU"
    }
  }
end

