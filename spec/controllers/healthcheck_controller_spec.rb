describe HealthCheckController, type: :controller do

  describe '#ping' do
    before { get :ping }

    subject { response }

    it { is_expected.to have_http_status(:success) }

    context 'returned schema' do
      let(:keys) { %w(version_number build_date commit_id build_tag) }

      subject { JSON.parse(response.body)}

      it 'matches ping.json schema names' do
        expect(subject.keys).to eq keys
      end

      it 'matches ping.json schema key count' do
        expect(subject.count).to eq 4
      end
    end
  end

  describe '#healthcheck' do
    before { get :healthcheck }

    subject { response }

    it { is_expected.to have_http_status(:success) }

  end
end
