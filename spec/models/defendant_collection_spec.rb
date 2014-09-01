describe DefendantCollection do

  let(:dc)        { DefendantCollection.new(claim_params) }

  describe '.new' do
    it 'should instantiate a collection with the correct number of defendants' do
      expect(dc).to be_instance_of DefendantCollection
      expect(dc.size).to eq 2
    end
  end
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
      "claimant_2" =>
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



