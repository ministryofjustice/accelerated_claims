require 'spec_helper'

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

      context '/new' do
        let(:referrer_path) { '/new' }

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

      context '/accelerated' do
        let(:referrer_path) { '/accelerated' }

        it 'should clear session' do
          @controller.stub(:url_root).and_return '/accelerated'
          controller.should_receive(:reset_session)
          get :new
        end
      end

      context '/' do
        let(:referrer_path) { '/' }

        it 'should clear session' do
          controller.should_receive(:reset_session)
          get :new
        end
      end

    end
  end

  describe '#confirmation' do
    it 'should render the confirmation page' do
      get :confirmation
      expect(response).to render_template("confirmation")
    end
  end

  describe '#submission' do
    it 'should redirect to the confirmation page' do
      post :submission, claim: claim_post_data['claim']
      response.should redirect_to('/confirmation')
    end
  end

  describe '#download' do
    context 'with valid claim data' do
      it "should return a PDF" do
        post :submission, claim: claim_post_data['claim']
        get :download
        response.headers["Content-Type"].should eq "application/pdf"
      end
    end

    context 'with invalid claim data' do
      it 'should redirect to the claim form' do
        data = claim_post_data['claim']
        data['claimant_one'].delete('full_name')
        post :submission, claim: data
        get :download
        response.should redirect_to('/new')
      end
    end
  end

  describe '#landing' do
    it 'should render the landing page' do
      get :landing
      expect(response).to render_template("landing")
    end
  end
end
