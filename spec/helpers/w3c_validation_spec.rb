describe ClaimController, :type => :controller do
  render_views
  if ENV['w3c_validate']
    describe '#confirmation' do
      context 'with valid claim data' do
        it 'should pass validation' do
          @controller.session['claim'] = claim_post_data['claim']
          get :confirmation
          page_valid = validate_view(response,{w3c_debug: ENV['w3c_debug'] || false})
          expect(page_valid.errors.length).to eql(0)
        end
      end
    end
  end
end
