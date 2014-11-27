  def run_test (test_data)
    if ENV['w3c_validate']
      test = eval(test_data).to_h
      describe "#{test[:controller].camelize}Controller".safe_constantize , :type => :controller do
        render_views
        describe "##{test[:action]}" do
          it "should #{test[:test_name]}" do

            action = "#{test[:action]}".to_sym
            action_redir =  "#{test[:action_redir]}".to_sym
            action_redir_err =  "#{test[:action_redir_err]}".to_sym
            path_redir = test[:redirect_path]
            redirect_path = Rails.application.routes.recognize_path(path_redir, :method => :get) if path_redir.present?

            if 'POST'.match(test[:method])
              post action, { test[:param_name] => test[:params]}
              if response.code!=200 && redirect_path.present?
                expect(response).to redirect_to(redirect_path)
                get action_redir_err if action_redir_err.present?
                get action_redir if action_redir.present?
              end
            elsif !test[:action_redir].blank? && 'GET'.match(test[:method])
              get action
              expect(response).to redirect_to(redirect_path)
              get action_redir
            elsif 'GET'.match(test[:method])
              get action
            end

            page_valid = validate_view(response)
            
            puts page_valid.message if ENV['w3c_debug'] && !page_valid.message.nil?
            if page_valid.result=='error'
              expect(page_valid.message).not_to eql(nil)
              raise page_valid.message
            elsif page_valid.result=='fail'
              expect(page_valid.errors.length).to eql(0)
              raise page_valid.message
            else
              expect(page_valid.errors.length).to eql(0)
            end
          end
        end
      end
    end
  end

  eval(IO.read('spec/fixtures/w3c_data.rb')).each do |test|
    eval(%Q|
          run_test '#{test}'
      |)
  end
