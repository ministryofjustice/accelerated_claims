describe FeedbackController do

  describe "#new" do
    it "should render the new feedback form" do
      get :new
      response.should render_template("new")
    end
  end

  describe '#create' do
    before do
      ZendeskHelper.stub(:send_to_zendesk).once
    end

    def do_post(text='feedback')
      post :create, feedback: { email: 'test@lol.biz.info', text: text }
    end

    it 'redirects to the homepage' do
      do_post
      response.should redirect_to root_path
    end

    it 'sends feedback to zendesk' do
      ZendeskHelper.should_receive(:send_to_zendesk).once
      do_post
    end

    context 'with test text' do
      it 'does not send feedback' do
        ZendeskHelper.should_not_receive(:send_to_zendesk)
        do_post Feedback::TEST_TEXT
      end
    end

    it 'should set the flash message' do
      do_post
      flash[:notice].should == 'Thanks for your feedback.'
    end
  end

end
