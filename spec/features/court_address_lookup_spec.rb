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

    context 'when JavaScript is not enabled' do
      scenario 'should have the correct form title' do
        expect(page).to have_text original_form_label
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

  context 'court address form' do
    scenario 'when the form is hidden' do
      visit '/'
      find('#court-details').click
      expect(page).to have_css('#court-address', visible: true)
    end

    scenario 'when the form is shown' do
      visit '/'
      2.times { find('#court-details').click }
      expect(page).to have_css('#court-address', visible: false)
    end
  end

  context 'when property address is populated' do
    let(:postcode) { 'SG8 0LT' }
    let(:json) {
      [
       {
         'name' => 'Cambridge County Court and Family Court',
         'address' => {
           'town' => 'Cambridge',
           'address_lines' => ['Cambridge County Court and Family Court Hearing Centre',
                               '197 East Road'],
           'type' => 'Postal',
           'postcode' => 'CB1 1BA',
           'county' => 'Cambridgeshire'
         }
       }
      ].to_json
    }

    before { court_finder_stub(postcode, body: json) }

    scenario 'should find and populate court name', js: true do
      visit '/'
      fill_in 'claim_property_postcode', with: postcode
      expect(page).to have_text 'Cambridge County Court and Family Court'
    end

    scenario 'should find and populate court address details in the hidden form', js: true do
      visit '/'
      fill_in 'claim_property_postcode', with: postcode
      json_address = JSON.parse(json)[0]['address']['address_lines'].join(',')
      address = find("#claim_court_street", visible: false).value
      expect(address).to eq json_address
    end

    context 'with an invalid postcode' do
      let(:postcode) { 'fake' }

      before { court_finder_stub(postcode, body: {}.to_json) }

      before(:each) do
        visit '/'
        fill_in 'claim_property_postcode', with: postcode
      end

      scenario 'should change the court name form label', js: true do
        label = find('#court-address-label').text
        expect(label).to eq original_form_label
      end

      scenario 'display the expanded form', js: true do
        court_address = find('#claim_court_street', visible: true)
        expect(court_address.visible?).to be true
      end

      context 'form toggle link' do
        scenario 'have a toggle link on load', js: true do
          # label = find('#court-details').text
          # text = 'Choose to send this claim to a different court'
          # expect(label).to eq text
          # expect(label).to eq original_form_label
        end

        scenario 'remove the form toggle link', js: true do
        end
      end
    end
  end
end
