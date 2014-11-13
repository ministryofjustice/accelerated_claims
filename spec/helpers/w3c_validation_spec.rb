require 'w3c_validators'

include W3CValidators

describe ClaimController, :type => :controller do
  render_views
  describe '#confirmation' do
    context 'with valid claim data' do
      it 'should render the confirmation page' do
        @validator = MarkupValidator.new

        # override the DOCTYPE
        @validator.set_doctype!(:html32)

        # turn on debugging messages
        @validator.set_debug!(true)

        @controller.session['claim'] = claim_post_data['claim']
        get :confirmation
        expect(response).to render_template("confirmation")
        results = @validator.validate_file(response.body)

        if results.errors.length > 0
          results.errors.each do |err|
            puts err.to_s
          end
        else
          puts 'Valid!'
        end

        puts 'Debugging messages'

        results.debug_messages.each do |key, value|
          puts "#{key}: #{value}"
        end
      end
    end
  end
end
