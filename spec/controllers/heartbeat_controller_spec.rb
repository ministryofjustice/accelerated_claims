describe HeartbeatController, :type => :controller do

  subject { response }

  describe '#ping' do
    before do
      ENV['APP_VERSION'] = version_number
      ENV['APP_BUILD_DATE'] = build_date
      ENV['APP_GIT_COMMIT'] = commit_id
      ENV['APP_BUILD_TAG'] = build_tag

      get :ping
    end

    after do
      ENV['APP_VERSION'] = nil
      ENV['APP_BUILD_DATE'] = nil
      ENV['APP_GIT_COMMIT'] = nil
      ENV['APP_BUILD_TAG'] = nil
    end

    context 'when environment variables are not set' do
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
    before do
      stub_request(:get, 'http://localhost:4000').to_return(status: status)
      get :healthcheck
    end

    context 'when everything is ok' do
      let(:status) { 200 }

      let(:expected_response) do
        {
          checks: { server: true, strike: true }
        }.to_json
      end

      it { is_expected.to have_http_status(:success) }

      it 'returns the expected response report' do
        expect(subject.body).to eq(expected_response)
      end
    end

    context 'when strike is down' do

      let(:status) { 500 }

      let(:expected_response) do
        {
          checks: { server: true, strike: false }
        }.to_json
      end

      it { is_expected.to have_http_status(:error) }

      it 'returns the expected response report' do
        expect(subject.body).to eq(expected_response)
      end
    end
  end
end
