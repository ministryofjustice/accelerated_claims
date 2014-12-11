feature 'Court address lookup' do

  unless remote_test?

    before do
      WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/])
    end

    let(:original_form_label) do
      'Enter the name and address of the court you want to send this claim to.'
    end

    context 'when the page is loaded' do

      before(:each) { visit '/' }

      scenario 'should not show the court address form', js: true do
        expect(page).to have_css('#court-address', visible: false)
      end

      unless remote_test?
        context 'when JavaScript is not enabled' do
          scenario 'should have the correct form title' do
            expect(page).to have_text original_form_label
          end
        end
      end

      context 'when JavaScript is enabled' do
        scenario 'should have the correct form title', js: true do
          js_form_label = "You haven't entered a postcode for the property you want to take back. To see the court you need to send this claim to, enter the postcode now"
          expect(page).to have_text js_form_label
        end

        scenario 'should have the link back to property section', js: true do
          form_title = 'You haven\'t entered a postcode for the property you want to take back. To see the court you need to send this claim to, <a href="#property">enter the postcode now</a>'
          element = page.evaluate_script("$('#court-address-label').html()")
          expect(element).to eq form_title
        end
      end
    end

    context 'when the form is populated correctly and submited' do
      context 'summary page is viewed and the user returns back to the form' do
        unless ENV["env"] == 'production'
          let(:court_data) do
            [{
                'name' => 'Bournemouth and Poole County Court and Family Court',
                'address' => {
                  'town' => 'Bournemouth',
                  'address_lines' => ['Bournemouth and Poole County Court
                                      and Family Court hearing
                                      centre'.sub('  ', ''),
                                      'Courts of Justice',
                                      'Deansleigh Road'],
                  'type' => 'Visiting',
                  'postcode' => 'BH7 7DS',
                  'county' => 'Dorset'
                }
             }]
          end

          before {
            allow_any_instance_of(Courtfinder::Client::HousingPossession).to \
              receive(:get).and_return(court_data)
          }

          scenario 'should display the court name', js: true do
            data = load_fixture_data 'spec/fixtures/scenario_01_js_data.rb'
            AppModel.new(data).exec do
              visit '/'
              claim_form.complete_form_with_javascript
              click_button 'Continue'
              find('div.summary') # ensure confirmation page loaded

              visit '/'
              find('form#claimForm') # ensure form page loaded

              expect(page).not_to have_text "You haven't entered a postcode for the property you want to take back."
            end
          end

          scenario 'should allow resubmission with a changed property address', js: true do
            data = load_fixture_data 'spec/fixtures/scenario_01_js_data.rb'
            AppModel.new(data).exec do
              visit '/'
              claim_form.complete_form_with_javascript
              click_button 'Continue'
              find('div.summary') # ensure confirmation page loaded
              visit '/'
              find('form#claimForm') # ensure form page loaded

              # click 'Change' to change the postcode for the property
              page.find(:xpath, '//*[@id="property"]/div/div[3]/div[3]/div/a').click

              fill_text_field 'claim_property_postcode_edit_field', 'W93XX'
              click_link 'Find address'
              click_button 'Continue'
              expect(page).not_to have_text 'Review the details of your claim'
            end
          end
        end
      end
    end

    context 'when property address is populated' do
      let(:postcode) { 'BH22 8HR' }
      let(:court_data) do
        [{
           'name' => 'Bournemouth and Poole County Court and Family Court',
           'address' => {
             'town' => 'Bournemouth',
             'address_lines' => ['Bournemouth and Poole County Court and
                                  Family Court hearing centre'.sub('  ', ''),
                                 'Courts of Justice',
                                 'Deansleigh Road'],
             'type' => 'Visiting',
             'postcode' => 'BH7 7DS',
             'county' => 'Dorset'
           }
        }]
      end

      let(:court_name) do
        'Bournemouth and Poole County Court and Family Court'
      end

      before do
        allow_any_instance_of(Courtfinder::Client::HousingPossession).to \
          receive(:get).and_return(court_data)
      end

      scenario 'find and populate court name, address, show manual edit link', js: true do
        visit '/'
        fill_text_field 'claim_property_postcode_edit_field', postcode
        click_link 'Find address'
        find('#claim_property_address_select').find(:xpath, 'option[1]').select_option
        click_on 'Select address'

        court_name_on_page = find(:xpath, '//*[@id="court-name"]/b').text
        expect(court_name_on_page).to have_text court_name

        address = court_data[0]['address']['address_lines'].join(',')
        court_address_on_page = find("#claim_court_street", visible: false).value
        expect(court_address_on_page).to eq(address)

        expect(page).to have_xpath('//*[@id="court-details"]')
      end

      context 'court address form visibility' do
        scenario 'should unhide the form', js: true do
          visit '/'
          fill_text_field 'claim_property_postcode_edit_field', postcode
          click_link 'Find address'
          find('#claim_property_address_select').find(:xpath, 'option[1]').select_option
          click_link 'Select address'

          find('#court-details').click
          expect(page).to have_css('#court-address', visible: true)
        end

        scenario 'the form should be togglable', js: true do
          visit '/'
          fill_text_field 'claim_property_postcode_edit_field', postcode
          click_link 'Find address'
          find('#claim_property_address_select').find(:xpath, 'option[1]').select_option
          click_link 'Select address'

          2.times { find('#court-details').click }
          expect(page).to have_css('#court-address', visible: false)
        end
      end

      context 'with an invalid postcode' do
        let(:postcode) { 'fake' }

        before { court_finder_stub(postcode, body: {}.to_json) }

        before(:each) do
          visit '/'
          fill_text_field 'claim_property_postcode_edit_field', postcode
          click_link 'Find address'
        end

        scenario 'should change the court name form label', js: true do
          no_postcode_label = <<-END.gsub(/(^\s+\||\n)/, '')
            |You haven't entered a postcode for the property
            | you want to take back. To see the court you need
            | to send this claim to, enter the postcode now.
          END

          label = find('#court-address-label').text
          expect(label).to eq no_postcode_label
        end

        scenario "don't expanded the form", js: true do
          court_address = find('#claim_court_street', visible: false)
          expect(court_address.visible?).to_not be true
        end

        context 'form toggle link' do
          let(:postcode) { 'BH22 8HR' }
          scenario 'have a toggle link on load', js: true do
            visit '/'
            fill_text_field 'claim_property_postcode_edit_field', postcode
            click_link 'Find address'
            find('#claim_property_address_select').find(:xpath, 'option[1]').select_option
            click_link 'Select address'

            expect(page).to have_css('#court-address', visible: false)
            page.find('#court-details').click
            expect(page).to have_css('#court-address', visible: true)
          end

          scenario 'remove the form toggle link', js: true do
          end
        end
      end

      context 'and is subsequently removed' do
        scenario 'the court address should be removed also', js: true do
          visit '/'
          fill_text_field 'claim_property_postcode_edit_field', postcode
          # click the first 'Find address' button
          find(:xpath, '//*[@id="property"]/div/div[1]/div[2]/a').click
          find('#claim_property_address_select').find(:xpath, 'option[1]').select_option
          # click the first  'Select address' button
          find(:xpath, '//*[@id="claim_property_selectaddress"]').click
          expect(page).to have_text "You need to post this claim to the court nearest the property you're taking back:"
          find(:xpath, '//*[@id="property"]/div/div[3]/div[3]/div').click

          # click 'Change'
          find(:xpath, '//*[@id="property"]/div/div[3]/div[3]/div/a').click

          ['court_name', 'street', 'postcode'].each do |value|
            form_field_value = find(:xpath, "//*[@id='claim_court_#{value}']", visible: false).value
            expect(form_field_value).to eq ''
          end
        end
      end
    end
  end
end
