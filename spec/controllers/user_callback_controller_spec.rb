describe UserCallbackController, :type => :controller do

  describe "#new" do
    it "should render the new feedback form" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe '#create' do
    let(:callback_params) do
      { name: 'Mike Smith', phone: '02011112222', description: 'Please call me!' }
    end

    it 'sends feedback to zendesk' do
      expect(ZendeskHelper).to receive(:callback_request).once
      post :create, user_callback: callback_params
    end

    describe 'redirect' do
      let(:referrer_path) { root_path }
      let(:return_to) { nil }

      before do
        allow(controller.request).to receive(:referrer) { referrer_path }
        session[:return_to] = return_to
        get :new
        post :create, user_callback: callback_params
      end

      context 'request referrer is homepage' do
        it 'redirects to the homepage' do
          expect(response).to redirect_to root_path
        end
      end

      context 'request referrer is confirmation page' do
        let(:referrer_path) { confirmation_path }

        it 'redirects to confirmation page' do
          expect(response).to redirect_to confirmation_path
        end
      end

      context 'request referrer is feedback form' do
        let(:referrer_path) { feedback_path }

        context 'and session[:return_to] is nil' do
          it 'redirects to homepage' do
            expect(response).to redirect_to root_path
          end
        end

        context 'and session[:return_to] is confirmation page' do
          let(:return_to) { confirmation_path }

          it 'redirects to confirmation page' do
            expect(response).to redirect_to confirmation_path
          end
        end
      end

      context 'request referrer is technical help form' do
        let(:referrer_path) { technical_help_path }

        context 'and session[:return_to] is nil' do
          it 'redirects to homepage' do
            expect(response).to redirect_to root_path
          end
        end

        context 'and session[:return_to] is confirmation page' do
          let(:return_to) { confirmation_path }

          it 'redirects to confirmation page' do
            expect(response).to redirect_to confirmation_path
          end
        end
      end
    end

  end
end
