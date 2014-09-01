describe DefendantCollection do

  let(:dc)        { DefendantCollection.new(claim_params) }

  describe '.new' do
    it 'should instantiate a collection with the correct number of defendants' do
      expect(dc).to be_instance_of DefendantCollection
      expect(dc.size).to eq 2
    end

    it 'should fail if the number of defendants in the params is less than the number given in the initializer' do
        params = claim_params
        params[:num_defendants] = 3
        dc2 = DefendantCollection.new(params)
        expect(dc2).not_to be_valid
        expected_errors = [
              "Defendant 3 title Enter defendant 3's title",
              "Defendant 3 full name Enter defendant 3's full name",
              "Defendant 3 street Enter defendant 3's full address",
              "Defendant 3 postcode Enter defendant 3's postcode"
            ]
        expect(dc2.errors.full_messages).to eq expected_errors
    end
  end
end








def claim_params
  HashWithIndifferentAccess.new(
    { "num_defendants" => 2,
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
      }
    }
  )
end



