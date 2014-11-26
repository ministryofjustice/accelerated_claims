  def run_context (test_data)
    if ENV['w3c_validate']
      test = eval(test_data).to_h
      describe "#{test[:controller].camelize}Controller".constantize , :type => :controller do
        render_views
        describe "##{test[:action]}" do
          it 'should render valid html' do

            action = "#{test[:action]}".to_sym
            action_redir =  "#{test[:action_redir]}".to_sym

            path_redir = test[:redirect_path]
            redirect_path = Rails.application.routes.recognize_path(path_redir, :method => :get) if !path_redir.nil?

            if !test[:action_redir].blank? && 'GET'.match(test[:method])
              get action
              expect(response).to redirect_to(redirect_path)
              get action_redir
            elsif 'GET'.match(test[:method])
              get action
            end
            page_valid = validate_view(response,{w3c_debug: test[:w3c_debug] || false})
            if page_valid.result=='error'
              # @validation_results.increment_errors
              expect(page_valid.message).not_to eql(nil)
              raise page_valid.message
            elsif page_valid.result=='fail'
              expect(page_valid.errors.length).to eql(0)
              raise page_valid.message
            else
              expect(page_valid.errors.length).to eql(0)
              # @validation_results.increment_passes
            end
          end
        end
      end
    end
  end

  eval(IO.read('spec/fixtures/w3c_data.rb')).each do |test|
    eval(%Q|
          run_context '#{test}'
      |)
  end
