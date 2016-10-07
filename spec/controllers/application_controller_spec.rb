describe ApplicationController, :type => :controller do
  describe 'expired token behaviour' do
    context 'when the user has an invalid session token' do
      it 'should redirect the user' do
        post :invalid_access_token, {}
        expect(response).to redirect_to(File.join(root_path, 'expired'))
      end
    end
  end
end
