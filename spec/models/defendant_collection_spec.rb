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
              "Defendant 4 full name Enter defendant 4's full name"
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

    let(:defendant)   { Defendant.new( { "title" => "Mrs", "full_name" => "Maggie Thatcher", "street" => "10 Downing Street St\nLondon", "postcode" => "SW1W 7LU"} ) }
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

  context 'instantiating with an empty array' do
    it 'should intantiate a collection of 20 empty objects' do
      dc = DefendantCollection.new( HashWithIndifferentAccess.new )
      expect(dc.size).to eq 0
      expect(empty_defendant?(dc[1])).to be true
      expect(empty_defendant?(dc[2])).to be true
      expect(empty_defendant?(dc[3])).to be true
      expect(empty_defendant?(dc[4])).to be true
      expect(empty_defendant?(dc[5])).to be true
      expect(empty_defendant?(dc[6])).to be true
      expect(empty_defendant?(dc[15])).to be true
      expect(empty_defendant?(dc[19])).to be true
      expect(empty_defendant?(dc[20])).to be true
    end
  end

  describe '.max_defendants' do
    it 'should return the maximum number of defendants for js_enabled if not given a param' do
      expect(DefendantCollection.max_defendants).to eq 20
    end

    it 'should return the maximum number of defendants for js_enabled if given true' do
      expect(DefendantCollection.max_defendants(js_enabled: true)).to eq 20
    end

    it 'should return the maximum number of defendants for js_disabled if given false' do
      expect(DefendantCollection.max_defendants(js_enabled: false)).to eq 4
    end

  end

  describe '#further_participants' do
    it 'should return an emtpy array if empty collection' do
      dc = DefendantCollection.new( HashWithIndifferentAccess.new )
      expect(dc.further_participants).to be_empty
    end

    it 'should return an array of two defendants if two defendants in collection' do
      params = claim_params
      params.delete('defendant_3')
      params['num_defendants'] = 2
      dc = DefendantCollection.new(params)
      expect(dc.size).to eq 2
      expect(dc.further_participants).to eq [ dc[1], dc[2] ]
    end

    it 'should return an array of 6 defendants if 6 defendants in collection' do
      params = claim_params_for_six_defendants
      dc = DefendantCollection.new(params)
      expect(dc.size).to eq 6
      expect(dc.further_participants).to eq [ dc[1], dc[2], dc[3], dc[4], dc[5], dc[6] ]
    end
  end

  context 'validation' do

    let(:invalid_params) do
      params = claim_params
      params['defendant_1']['title']     = ''
      params['defendant_2']['full_name'] = ''
      params['defendant_3']['postcode']  = ''
      params
    end

    it 'should not be valid if given invalid params' do
      dc = DefendantCollection.new(invalid_params)
      expect(dc).not_to be_valid
    end

    it 'should have error messages for the missing fields' do
      dc = DefendantCollection.new(invalid_params)
      dc.valid?
      expect(dc.errors[:defendant_2_full_name]).to eq ["Enter defendant 2's full name"]
    end

    it 'should reject addresses with too many lines for defendant 1' do
      params = claim_params
      params['defendant_1']['street'] = "line 1\nline 2\nline 3\nline 4\nline 5"
      dc = DefendantCollection.new(params)
      expect(dc).not_to be_valid
      expect(dc.errors[:defendant_1_street]).to eq(["Defendant 1's address can’t be longer than 4 lines"])
    end
  end
end

def empty_defendant?(obj)
  obj.is_a?(Defendant) && obj.empty?
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
        "postcode" => "FX1W 7LU"
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
      },
      "property" =>
      {
        "street" => "2 Toytown Road\nToytown",
        "postcode" => "FX8X 8XX"
      }
    }
  )
end

def claim_params_for_six_defendants
  HashWithIndifferentAccess.new(
    { "num_defendants" => 6,
      "defendant_1" =>
      {
        "title" => "Miss",
        "full_name" => "Ann Chovey",
        "inhabits_property" => 'No',
        "street" => "3 High Stree\nAnytown",
        "postcode" => "FX1W 7LU"
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
      },
      "defendant_4" =>
      {
        "title" => "Miss",
        "full_name" => "Ann Chovey",
        "inhabits_property" => 'No',
        "street" => "4 High Stree\nAnytown",
        "postcode" => "FX4W 4LU"
      },
      "defendant_5" =>
      {
        "title" => "Miss",
        "full_name" => "Barb Akew",
        "inhabits_property" => 'Yes',
        "street" => "",
        "postcode" => ""
      },
      "defendant_6" =>
      {
        "title" => "Mr",
        "full_name" => "Joe Blow",
        "inhabits_property" => 'No',
        "street" => "666 Made-up Lane\nAnytown",
        "postcode" => "F66 6LU"
      },

      "property" =>
      {
        "street" => "2 Toytown Road\nToytown",
        "postcode" => "FX8X 8XX"
      }
    }
  )
end

