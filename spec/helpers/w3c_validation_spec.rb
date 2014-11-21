describe ClaimController, :type => :controller do
  if ENV['w3c_validate']
    render_views
    describe "#new" do
      it 'should render valid' do
        get :new
        expect(response.body).to include('Make a claim to evict tenants')
        page_valid = validate_view(response,{w3c_debug: ENV['w3c_debug'] || false})
        expect(page_valid.errors.length).to eql(0)
      end
      it 'when submitted with invalid claim data should re-render new and be valid' do
        data = claim_post_data['claim']
        data['claimant_1'].delete('full_name')
        @controller.session['claim'] = data
        get :confirmation
        expect(response).to redirect_to(root_path)
        get :new
        expect(response.body).to include('Make a claim to evict tenants')
        expect(response.body).to include('See highlighted errors below')
        page_valid = validate_view(response,{w3c_debug: ENV['w3c_debug'] || false})
        expect(page_valid.errors.length).to eql(0)
      end
    end
    describe '#confirmation' do
      it 'should render valid html' do
        data = claim_post_data['claim']
        @controller.session['claim'] = data
        get :confirmation
        expect(response.body).to include('Check all the information on this page before clicking ‘Print the form’.')
        page_valid = validate_view(response,{w3c_debug: ENV['w3c_debug'] || false})
        expect(page_valid.errors.length).to eql(0)
      end
    end
  end
end
describe FeedbackController, :type => :controller do
  if ENV['w3c_validate']
    render_views
    describe "#new" do
      it "should render a valid feedback form" do
        get :new
        expect(response.body).to include('Did you have any difficulty with this service?')
        page_valid = validate_view(response,{w3c_debug: ENV['w3c_debug'] || false})
        expect(page_valid.errors.length).to eql(0)
      end
    end
  end
end
describe UserCallbackController, :type => :controller do
  if ENV['w3c_validate']
    render_views
    describe "#new" do
      it 'should render a valid page' do
        get :new
        expect(response.body).to include('Please note: we cannot offer legal advice.')
        page_valid = validate_view(response,{w3c_debug: ENV['w3c_debug'] || false})
        expect(page_valid.errors.length).to eql(0)
      end
      it 'should render a valid page after invalid data is submitted' do
        @params = {
            name: '',
            phone: '',
            description: ''
          }
        post :create, user_callback: @params
        expect(response.body).to include('Please note: we cannot offer legal advice.')
        expect(response.body).to include('See highlighted errors below')
        page_valid = validate_view(response,{w3c_debug: ENV['w3c_debug'] || false})
        expect(page_valid.errors.length).to eql(0)
      end
    end
  end
end

