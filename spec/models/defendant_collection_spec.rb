describe DefendantCollection do

  let(:dc)        { DefendantCollection.new(claim_params) }

  describe '.new' do
    it 'should instantiate a collection with the correct number of defendants' do
      expect(dc).to be_instance_of DefendantCollection
      expect(dc.size).to eq 3
    end

    it 'should fail if the number of defendants in the params is less than the number given in the initializer' do
        params = claim_params
        params[:num_defendants] = 4
        dc2 = DefendantCollection.new(params)
        expect(dc2).not_to be_valid
        expected_errors = [
              "Defendant 4 inhabits property Please select whether or not defendant 4 lives in the property",
              "Defendant 4 title Enter defendant 4's title",
              "Defendant 4 full name Enter defendant 4's full name",
              "Defendant 4 street Enter defendant 4's full address",
              "Defendant 4 postcode Enter defendant 4's postcode"
            ]
        expect(dc2.errors.full_messages).to eq expected_errors
    end

    it 'should return size of zero with 1 empty defendant if instantiated with empty params' do
      dc2 = DefendantCollection.new({})
      expect(dc2.size).to eq 0
    end

    it 'should insert defendant with validate absence = true if more than the num_defendants' do
      params = claim_params
      params['num_defendants'] = 2
      dc2 = DefendantCollection.new(params)
      valid_defendant = dc2[1]
      expect(valid_defendant.validate_absence?).to be false
      expect(valid_defendant.valid?).to be true

      valid_defendant = dc2[2]
      expect(valid_defendant.validate_absence?).to be false
      expect(valid_defendant.valid?).to be true

      invalid_defendant = dc2[3]
      expect(invalid_defendant.validate_absence?).to be true
      expect(invalid_defendant.valid?).to be false
      expect(dc2.size).to eq 2
    end
  end

  describe '#[]' do
    it 'should return the defendant of the given index' do
      defendant = dc[2]
      expect(defendant).to be_instance_of(Defendant)
      expect(defendant.full_name).to eq "Barb Akew"
    end

    it 'should raise error if index 0 is given' do
      expect {
        dc[0]
      }.to raise_error ArgumentError, "No such index: 0"
    end
  

    it 'should return empty claimant if the index is higher than the number of claimants' do
      defendant = dc[4]
      expect(defendant.empty?).to be true
    end
  end


  describe '#[]=' do

    let(:defendant)   { Defendant.new( { "title" => "Mrs", "full_name" => "Maggie Thatcher", "street" => "10 Downing Street St\nLondon", "postcode" => "SW1W 0LU"} ) }
    it 'should raise error if index is zero' do
      expect {
        dc[0] = defendant
      }.to raise_error ArgumentError, "Invalid index: 0"
    end

    it 'should raise error if index is greater than number of claimants' do
      expect {
        dc[4] = defendant
      }.to raise_error ArgumentError, "Invalid index: 4"
    end

    it 'should replace the specified claimant with the new claimant' do
      dc[3] = defendant
      d = dc[3]
      expect(d.full_name).to eq 'Maggie Thatcher'
    end
  end


  describe 'as_json' do
    it 'should produce a json representation of the contacts' do
      expect(dc.as_json).to eq expected_json(dc)
    end
  end

end



def expected_json(dc)
  {'defendant_1' => dc[1].as_json, 'defendant_2' => dc[2].as_json, 'defendant_3' => dc[3].as_json }.as_json
end





def claim_params
  HashWithIndifferentAccess.new(
    { "num_defendants" => 3,
      "defendant_1" =>
      {
        "title" => "Miss",
        "full_name" => "Ann Chovey",
        "inhabits_property" => 'No',
        "street" => "3 High Stree\nAnytown",
        "postcode" => "FX1W 0LU"
      },
      "defendant_2" =>
      {
        "title" => "Miss",
        "full_name" => "Barb Akew",
        "inhabits_property" => 'Yes',
        "street" => "",
        "postcode" => ""
      },
      "defendant_3" =>
      {
        "title" => "Mr",
        "full_name" => "Joe Blow",
        "inhabits_property" => 'No',
        "street" => "666 Made-up Lane\nAnytown",
        "postcode" => "FX4W 9LU"
      }
    }
  )
end



