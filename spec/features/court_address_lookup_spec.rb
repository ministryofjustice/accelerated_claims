feature 'Court address lookup' do
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
        form_title = 'You haven\'t entered a postcode for the property you want to take back.<br> To see the court you need to send this claim to, <a href="#property">enter the postcode now</a>'
        element = page.evaluate_script("$('#court-address-label').html()")
        expect(element).to eq form_title
      end
    end
  end

  context 'when property address is populated' do
    let(:postcode) { 'BH22 8HR' }
    let(:json) { CourtfinderController::TEST_RESPONSE_DATA.to_json }

    before { court_finder_stub(postcode, body: json) }

    scenario 'find and populate court name, address, show manual edit link', js: true do
      visit '/'
      fill_text_field 'claim_property_postcode_edit_field', postcode
      click_link 'Find address'
      find('#claim_property_address_select').find(:xpath, 'option[1]').select_option
      click_link 'Select address'

      expect(page).to have_text 'Cambridge County Court and Family Court'

      address = JSON.parse(json)[0]['address']['address_lines'].join(',')
      expect( page.find("#claim_court_street", visible: false).value ).to eq(address)

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
          | to send this claim to, enter the postcode now
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
