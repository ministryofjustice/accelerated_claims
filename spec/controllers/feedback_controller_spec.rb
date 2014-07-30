describe FeedbackController, :type => :controller do

  describe "#new" do
    it "should render the new feedback form" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe '#create' do
    before do
      allow(ZendeskHelper).to receive(:send_to_zendesk).once
    end

    def do_post(text='feedback')
      post :create, feedback: { email: 'test@lol.biz.info',
          difficulty_feedback: text,
          improvement_feedback: 'y',
          satisfaction_feedback: 'z',
          help_feedback: 'a' }
    end

    it 'redirects to the homepage' do
      do_post
      expect(response).to redirect_to root_path
    end

    it 'sends feedback to zendesk' do
      expect(ZendeskHelper).to receive(:send_to_zendesk).once
      do_post
    end

    context 'with test text' do
      it 'does not send feedback' do
        expect(ZendeskHelper).not_to receive(:send_to_zendesk)
        do_post Feedback::TEST_TEXT
      end
    end

    it 'should set the flash message' do
      do_post
      expect(flash[:notice]).to eq('Thanks for your feedback.')
    end
  end

end
