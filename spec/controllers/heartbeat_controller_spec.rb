describe HeartbeatController, :type => :controller do

  subject { response }

  describe '#ping' do
    before do
      ENV['VERSION_NUMBER'] = version_number
      ENV['BUILD_DATE'] = build_date
      ENV['COMMIT_ID'] = commit_id
      ENV['BUILD_TAG'] = build_tag

      get :ping
    end

    context 'when environment variables not set' do
      let(:version_number) { nil }
      let(:build_date) { nil }
      let(:commit_id) { nil }
      let(:build_tag) { nil }

      it { is_expected.to have_http_status(:success) }

      it 'returns "Not Available"' do
        expect(JSON.parse(response.body).values).to eq( ['Not Available', 'Not Available', 'Not Available', 'Not Available'])
      end
    end

    context 'when environment variables are set' do
      let(:version_number) { '123' }
      let(:build_date) { '20150721' }
      let(:commit_id) { 'afb12cb3' }
      let(:build_tag) { 'test' }

      let(:expected_json) do
        {
          'version_number' => '123',
          'build_date' => '20150721',
          'commit_id' => 'afb12cb3',
          'build_tag' => 'test'
        }
      end

      it { is_expected.to have_http_status(:success) }

      it 'returns JSON with app information' do
        expect(JSON.parse(response.body)).to eq(expected_json)
      end
    end
  end

  describe '#healthcheck' do
    before { get :healthcheck }

    it { is_expected.to have_http_status(:success) }

    context 'when everything is ok' do
      let(:expected_response) do
        {
          checks: { server: true, strike: true }
        }.to_json
      end

      it 'returns the expected response report' do
        expect(subject.body).to eq(expected_response)
      end
    end

    context 'when strike is down' do
      before { stub_request(:get, 'http://localhost:4000').to_return(status: 500) }

      let(:expected_response) do
        {
          checks: { server: true, strike: false }
        }.to_json
      end

      it 'returns the expected response report' do
        expect(subject.body).to eq(expected_response)
      end
    end
  end
end
