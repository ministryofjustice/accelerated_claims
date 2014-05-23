describe ClaimController do
  render_views

  describe "#new" do
    it "should render the new claim form" do
      get :new
      expect(response).to render_template("new")
    end

    context 'referrer is' do
      before do
        @controller.request.stub(:referrer).and_return("http://example.com#{referrer_path}")
      end

      context '/' do
        let(:referrer_path) { '/' }

        it 'should not clear session' do
          controller.should_not_receive(:reset_session)
          get :new
        end
      end

      context '/confirmation' do
        let(:referrer_path) { '/confirmation' }

        it 'should not clear session' do
          controller.should_not_receive(:reset_session)
          get :new
        end
      end

      context '' do
        let(:referrer_path) { '' }

        it 'should not clear session' do
          controller.should_not_receive(:reset_session)
          get :new
        end
      end

      context 'is gov.uk landing page' do
        before {
          @controller.request.stub(:referrer).and_return('https://www.gov.uk/accelerated-possession-eviction')
        }
        let(:referrer_path) { nil }

        it 'should clear session' do
          controller.should_receive(:reset_session)
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
        response.should redirect_to('/')
      end
    end

    context 'with invalid claim data' do
      it 'should redirect to the claim form' do
        data = claim_post_data['claim']
        data['claimant_one'].delete('full_name')
        @controller.session['claim'] = data
        get :confirmation
        response.should redirect_to('/')
      end
    end
  end

  describe '#submission' do
    it 'should redirect to the confirmation page' do
      post :submission, claim: claim_post_data['claim']
      response.should redirect_to('/confirmation')
    end
  end

  describe 'GET download' do

    context 'with valid claim data' do
      it "should return a PDF" do
        stub_request(:post, "http://localhost:4000/").
        to_return(:status => 200, :body => "", :headers => {})

        post :submission, claim: claim_post_data['claim']
        get :download
        response.headers["Content-Type"].should eq "application/pdf"
      end
    end

    context "with 'flatten=false' parameter" do
      it 'should still return PDF' do
        stub_request(:post, "http://localhost:4000/").
        to_return(:status => 200, :body => "", :headers => {})

        post :submission, claim: claim_post_data['claim']
        get :download, params: { 'flatten' => 'false' }
        response.headers["Content-Type"].should eq "application/pdf"
      end
    end

    context 'with invalid claim data' do
      it 'should redirect to the claim form' do
        data = claim_post_data['claim']
        data['claimant_one'].delete('full_name')
        post :submission, claim: data
        get :download
        response.should redirect_to('/')
      end
    end
  end
end
