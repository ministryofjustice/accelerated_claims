describe CourtfinderController, type: :controller do

  def do_stub_with(postcode, body: '', code: 200)
    url = "#{Courtfinder::SERVER}#{Courtfinder::Client::HousingPossession::PATH}#{postcode}"
    stub_request(:get, url)
      .to_return(:status => 200, :body => body, :headers => {})
  end

  describe '#address' do
    context 'when a valid postcode is given' do
      let(:postcode) { 'SG8 0LT' }
      let(:json) do
        [
         {
           'name' => 'Cambridge County Court and Family Court',
           'address' => {
             'town' => 'Cambridge',
             'address_lines' => ['Cambridge County Court and Family Court Hearing Centre',
                                 '197 East Road'],
             'type' => 'Postal',
             'postcode' => 'CB1 1BA',
             'county' => 'Cambridgeshire'
           }
         }
        ].to_json
      end

      before { do_stub_with(postcode, body: json) }

      it 'should return the correct response code' do
        get :address, postcode: postcode
        expect(response.status).to eq 200
      end

      it 'should return valid JSON' do
        get :address, postcode: postcode
        expect(response.body).to eq json
      end
    end

    context 'when a invalid postcode is given' do
      let(:postcode) { 'broken' }

      before { do_stub_with(postcode, body: '', code: 404) }

      it 'should return error status code' do
        get :address, postcode: postcode
        expect(response.status).to eq 404
      end

      it 'should return error message' do
        get :address, postcode: postcode
        expect(response.body).to eq "No court found for #{postcode} postcode"
      end
    end
  end
end
