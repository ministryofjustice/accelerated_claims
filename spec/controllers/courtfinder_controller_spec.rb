describe CourtfinderController, type: :controller do
  describe '#address' do
    context 'when a valid postcode is given' do
      let(:postcode) { 'SG8 0LT' }
      # let(:json) { court_address }

      before do
        allow_any_instance_of(Courtfinder::Client::HousingPossession).to \
          receive(:get).and_return(court_address)
      end

      it 'should return the correct response code' do
        get :address, postcode: postcode
        expect(response.status).to eq 200
      end

      it 'should return valid JSON' do
        get :address, postcode: postcode
        expect(response.body).to eq court_address.to_json
      end
    end

    context 'when a invalid postcode is given' do
      let(:postcode) { 'fake' }

      before do
        allow_any_instance_of(Courtfinder::Client::HousingPossession).to \
          receive(:get).and_return('')
      end

      it 'should return error status code' do
        get :address, postcode: postcode
        expect(response.status).to eq 404
      end

      it 'should return error message' do
        get :address, postcode: postcode
        expect(response.body).to eq "No court found for #{postcode} postcode"
      end
    end

    context 'when error is returned' do
      let(:postcode) { 'foo bar' }
      let(:json_error) { { "error" => "Timeout" } }

      before do
        allow_any_instance_of(Courtfinder::Client::HousingPossession).to \
          receive(:get).and_return(json_error)
      end

      it 'should log the error' do
        expect(LogStuff).to receive(:error)
        get :address, postcode: postcode
      end

      it 'should return expected result' do
        get :address, postcode: postcode
        expect(response.body).to eq '[]'
      end
    end
  end
end
