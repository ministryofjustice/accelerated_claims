describe ClaimController, :type => :controller do
  render_views

  describe "#new" do
    it "should render the new claim form" do
      get :new
      expect(response).to render_template("new")
    end

    describe 'HTTP response headers' do
      subject { response }

      it 'set to blank (we set values in nginx conf)' do
        expect(response['X-Frame-Options']).to eq ''
        expect(response['X-Content-Type-Options']).to eq ''
        expect(response['X-XSS-Protection']).to eq ''
        expect(response['Pragma']).to eq ''
        expect(response['Cache-Control']).to eq ''
        expect(response['Expires']).to eq ''
      end
    end

    shared_examples 'session mantained' do
      it 'should not clear session' do
        expect(controller).not_to receive(:reset_session)
        get :new
      end
    end

    context 'referrer is' do
      before do
        allow(@controller.request).to receive(:referrer).and_return("http://example.com#{referrer_path}")
      end

      context '/' do
        let(:referrer_path) { '/' }
        it_behaves_like 'session mantained'
      end

      context '/confirmation' do
        let(:referrer_path) { '/confirmation' }
        it_behaves_like 'session mantained'
      end

      context '' do
        let(:referrer_path) { '' }
        it_behaves_like 'session mantained'
      end

      context 'is gov.uk landing page' do
        before {
          allow(@controller.request).to receive(:referrer).and_return('https://www.gov.uk/accelerated-possession-eviction')
        }
        let(:referrer_path) { nil }

        it 'should clear session' do
          expect(controller).to receive(:reset_session)
          get :new
        end
      end

    end
  end

  describe '#confirmation' do
    context 'with valid claim data' do
      it 'should render the confirmation page' do
        @controller.session['claim'] = claim_post_data['claim']
        get :confirmation
        expect(response).to render_template("confirmation")
      end
    end

    context 'with no claim data' do
      it 'should redirect to the claim form' do
        get :confirmation # no session
        expect(response).to redirect_to('/')
      end
    end

    context 'with invalid claim data' do
      it 'should redirect to the claim form' do
        data = claim_post_data['claim']
        data['claimant_1'].delete('full_name')
        @controller.session['claim'] = data
        get :confirmation
        expect(response).to redirect_to('/')
      end
    end
  end

  describe '#submission' do
    it 'should redirect to the confirmation page' do
      post :submission, claim: claim_post_data['claim']
      expect(response).to redirect_to('/confirmation')
    end
  end

  describe 'GET download' do

    context 'with valid claim data' do
      it "should return a PDF" do
        stub_request(:post, "http://localhost:4000/").
        to_return(:status => 200, :body => "", :headers => {})
        post :submission, claim: claim_post_data['claim']
        get :download
        expect(response.headers["Content-Type"]).to eq "application/pdf"
      end
    end

    context "with 'flatten=false' parameter" do
      it 'should still return PDF' do
        stub_request(:post, "http://localhost:4000/").
        to_return(:status => 200, :body => "", :headers => {})

        post :submission, claim: claim_post_data['claim']
        get :download, params: { 'flatten' => 'false' }
        expect(response.headers["Content-Type"]).to eq "application/pdf"
      end
    end

    context 'with invalid claim data' do
      it 'should redirect to the claim form' do
        data = claim_post_data['claim']
        data['claimant_1'].delete('full_name')
        post :submission, claim: data
        get :download
        expect(response).to redirect_to('/')
      end
    end

    context 'with expired session' do
      it 'should log and call app signal' do
        session[:claim] = nil
        env = double "Rails.env"
        allow(Rails).to receive(:production?).and_return(true)
        allow(env).to receive(:development?).and_return(false)
        logger = double "Rails.logger"
        allow(Rails).to receive(:logger).and_return(logger)
        expect(logger).to receive(:warn).with('User attepmted to download PDF from an expired session - redirected to /expired')

        get :download
        expect(response).to redirect_to('/expired')
      end
    end
  end

  describe 'GET data' do

    context 'with valid claim data' do
      it "should return json" do
        stub_request(:post, "http://localhost:4000/").
        to_return(:status => 200, :body => "", :headers => {})

        post :submission, claim: claim_post_data['claim']
        get :data
        expect(response.headers['Content-Type']).to include 'application/json'

        json = JSON.parse response.body

        claim_formatted_data.each do |field, value|
          value = "" if value.nil?
          value = nil if field[/tenancy_previous_tenancy_type/]
          expect(json).to include( field => value )
        end
      end
    end

    context 'with invalid claim data' do
      it 'should redirect to the claim form' do
        data = claim_post_data['claim']
        data['claimant_1'].delete('full_name')
        post :submission, claim: data
        get :data
        expect(response).to redirect_to('/')
      end
    end
  end
end
