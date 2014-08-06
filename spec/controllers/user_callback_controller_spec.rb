describe UserCallbackController, :type => :controller do

  describe "#new" do
    it "should render the new feedback form" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe '#create' do
    let(:form_params) do
      { name: 'Mike Smith', phone: '02011112222', description: 'Please call me!' }
    end

    it 'sends feedback to zendesk' do
      expect(ZendeskHelper).to receive(:callback_request).once
      post :create, user_callback: form_params
    end

    let(:model) { :user_callback }

    include_examples 'redirect after form submission'
  end
end
