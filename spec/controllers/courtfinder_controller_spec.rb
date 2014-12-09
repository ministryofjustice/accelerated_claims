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
      let(:postcode) { 'fake' }

      before { court_finder_stub(postcode, body: '', code: 404) }

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
      let(:json_error) { '{ "error": "Timeout" }' }

      before do
        ENV['ENV_NAME'] = 'production'
        WebMock.disable_net_connect!(allow: ["127.0.0.1", /codeclimate.com/])
        instance_double('Courtfinder::Client::HousingPossession', get: postcode)
      end

      after { ENV.delete('ENV_NAME') }

      def custom_stub(body)
        url = "https://courttribunalfinder.service.gov.uk/search/results.json?aol=Housing%20possession&postcode=#{postcode}"
        stub_request(:get, url).to_return(status: 400, body: body, headers: {})
      end

      it 'should log the error' do
        custom_stub(json_error)
        expect(LogStuff).to receive(:error)
        get :address, postcode: postcode
      end

      it 'should return expected result' do
        custom_stub(json_error)
        get :address, postcode: postcode
        expect(response.body).to eq "No court found for #{postcode} postcode"
      end
    end
  end
end
