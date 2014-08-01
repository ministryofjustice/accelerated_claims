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

    let(:text) { 'feedback' }
    let(:model) { :feedback }

    let(:form_params) do
      { email: 'test@lol.biz.info',
          difficulty_feedback: text,
          improvement_feedback: 'y',
          satisfaction_feedback: 'z',
          help_feedback: 'a' }
    end

    def do_post
      post :create, feedback: form_params
    end

    include_examples 'redirect after form submission'

    it 'sends feedback to zendesk' do
      expect(ZendeskHelper).to receive(:send_to_zendesk).once
      do_post
    end

    context 'with test text' do
      let(:text) { Feedback::TEST_TEXT }
      it 'does not send feedback' do
        expect(ZendeskHelper).not_to receive(:send_to_zendesk)
        do_post
      end
    end

    it 'should set the flash message' do
      do_post
      expect(flash[:notice]).to eq('Thanks for your feedback.')
    end
  end

end
