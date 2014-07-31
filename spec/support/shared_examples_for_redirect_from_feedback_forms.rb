shared_examples 'redirect after form submission' do
  describe 'redirect' do
    let(:referrer_path) { root_path }
    let(:return_to) { nil }

    before do
      allow(controller.request).to receive(:referrer) { referrer_path }
      session[:return_to] = return_to
      get :new
      params = { model => form_params }
      post :create, params
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
