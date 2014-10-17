describe CourtfinderController, type: :controller do
  describe '#address' do
    context 'when a valid postcode is given' do
      let(:postcode) { 'SG8 0LT' }
      let(:json) { CourtfinderController::TEST_RESPONSE_DATA.to_json }

      before { court_finder_stub(postcode, body: json) }

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

      before { court_finder_stub(postcode, body: '', code: 404) }

      pending 'should return error status code' do
        get :address, postcode: postcode
        expect(response.status).to eq 404
      end

      pending 'should return error message' do
        get :address, postcode: postcode
        expect(response.body).to eq "No court found for #{postcode} postcode"
      end
    end
  end
end
