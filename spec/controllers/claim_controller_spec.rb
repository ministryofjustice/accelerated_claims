describe ClaimController, :type => :controller do
  render_views

  context 'setting production and use_live_postcode_lookup' do
    it 'should not be produciton nor use_live_postcode_lookup in demo with nothing in url' do
      get :new
      expect(assigns(:production)).to be false
      expect(assigns(:use_live_postcode_lookup)).to be false
    end

    it 'should not be production but should be use_live_postcode_lookup if url contains use_live_postcode_lookup' do
      get :new, livepc: '1'
      expect(assigns(:production)).to be false
      expect(assigns(:use_live_postcode_lookup)).to be true
    end

    it 'should be both production and use_live_postcode_lookup on staging' do
      ENV['ENV_NAME'] = 'staging'
      get :new
      expect(assigns(:production)).to be true
      expect(assigns(:use_live_postcode_lookup)).to be true
      ENV['ENV_NAME'] = nil
    end

    it 'should be both production and use_live_postcode_lookup on production' do
      ENV['ENV_NAME'] = 'production'
      get :new
      expect(assigns(:production)).to be true
      expect(assigns(:use_live_postcode_lookup)).to be true
      ENV['ENV_NAME'] = nil
    end

  end

  describe "#new" do
    it "should render the new claim form" do
      get :new
      expect(response).to render_template("new")
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

      it 'should contain links to root_url' do
        @controller.session['claim'] = claim_post_data['claim']
        get :confirmation

        expect(response.body).to include("<a href='#{File.join(root_path,'#property-section')}'>Change property</a>")
      end
    end

    context 'with no claim data' do
      it 'should redirect to the claim form' do
        get :confirmation # no session
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid claim data' do
      it 'should redirect to the claim form' do
        data = claim_post_data['claim']
        data['claimant_1'].delete('full_name')
        @controller.session['claim'] = data
        get :confirmation
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#submission' do
    it 'should redirect to the confirmation page' do
      post :submission, claim: claim_post_data['claim']
      expect(response).to redirect_to(File.join(root_path,'/confirmation'))
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
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with expired session' do
      it 'should log and call app signal' do
        session[:claim] = nil
        env = double "Rails.env"
        allow(Rails).to receive(:env).and_return(env)
        allow(env).to receive(:production?).and_return(true)
        allow(env).to receive(:development?).and_return(false)

        get :download
        expect(response).to redirect_to(File.join(root_path,'expired'))
      end
    end

    context 'logging fee_account_num' do
      it 'should log fee account num logstash record if first time for this session' do
        expect(LogStuff).to receive(:info).with(:strike_through, :debug)
        expect(LogStuff).to receive(:info).with(:fee_account_num, { present: 'false', ip: instance_of(String) } )
        expect(session[:fee_account_num_logged]).to be_nil

        data = claim_post_data['claim']
        post :submission, claim: data
        get :download
        expect(session[:fee_account_num_logged]).to eq data['property']['postcode']
      end

      it 'should not log a fee account num if already done this session for the same postcode' do
        expect(LogStuff).not_to receive(:info).with(:fee_account_num, { present: 'false', ip: instance_of(String) } )
        data = claim_post_data['claim']
        session[:fee_account_num_logged] = data['property']['postcode']
        post :submission, claim: data
        get :download
      end

      it 'should log a fee account num if already done this session for a different postcode' do
        expect(LogStuff).to receive(:info).with(:strike_through, :debug)
        expect(LogStuff).to receive(:info).with(:fee_account_num, { present: 'false', ip: instance_of(String) } )
        data = claim_post_data['claim']
        session[:fee_account_num_logged] = data['property']['postcode'].tr('0123456789', '9876543210')  # ensure this postcode different from last
        post :submission, claim: data
        get :download
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
          if field == 'possession_hearing'
            value = value == 'Yes' ? 'No' : 'Yes'
          end
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
        expect(response).to redirect_to(root_path)
      end
    end
  end

end
