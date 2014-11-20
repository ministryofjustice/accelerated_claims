describe ClaimController, :type => :controller do
  if ENV['w3c_validate']
    render_views
    describe "#new" do
      it "before data added should be valid" do
        get :new
        page_valid = validate_view(response,{w3c_debug: ENV['w3c_debug'] || false})
        expect(page_valid.errors.length).to eql(0)
      end
    end
    describe '#confirmation' do
      context 'with invalid claim data should render new and' do
        it 'should pass validation' do
          data = claim_post_data['claim']
          data['claimant_1'].delete('full_name')
          @controller.session['claim'] = data
          get :confirmation
          expect(response).to redirect_to(root_path)
          get :new
          page_valid = validate_view(response,{w3c_debug: ENV['w3c_debug'] || false})
          expect(page_valid.errors.length).to eql(0)
        end
      end
    end
  end
end
describe FeedbackController, :type => :controller do
  if ENV['w3c_validate']
    render_views
    describe "#new" do
      it "should render the new feedback form" do
        get :new
        page_valid = validate_view(response,{w3c_debug: ENV['w3c_debug'] || false})
        expect(page_valid.errors.length).to eql(0)
      end
    end
  end
end
