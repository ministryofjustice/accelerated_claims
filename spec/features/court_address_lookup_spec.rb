feature 'Court address lookup' do
  before do
    WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/])
  end

  context 'when the page is loaded' do
    scenario 'should not show the court address form', js: true do
      visit '/'
      expect(page).to have_css('#court-address', visible: false)
    end

    context 'when JavaScript is not enabled' do
      scenario 'should have the correct form title' do
        visit '/'
        non_js_form_label = 'Enter the name and address of the court you want to send this claim to.'
        expect(page).to have_text non_js_form_label
      end
    end

    context 'when JavaScript is enabled' do
      scenario 'should have the correct form title', js: true do
        visit '/'
        js_form_label = "You need to post this claim to the court nearest the property you're taking back:"
        expect(page).to have_text js_form_label
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
  end
end
