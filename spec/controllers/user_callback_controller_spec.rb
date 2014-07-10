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

    it 'redirects to the homepage' do
      post :create, user_callback: callback_params
      expect(response).to redirect_to root_path
    end

    it 'sends feedback to zendesk' do
      expect(ZendeskHelper).to receive(:callback_request).once
      post :create, user_callback: callback_params
    end
  end
end
