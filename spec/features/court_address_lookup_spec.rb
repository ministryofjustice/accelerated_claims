feature 'Court address lookup' do

  before do
    WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/])
  end

  context 'when property address is populated' do
    scenario 'it should find and populate court name', js: true do
      visit '/'
      fill_in 'claim_property_postcode', with: 'SG8 0LT'

      expect(page).to have_text 'Cambridge County Court and Family Court Hearing Centre'
    end
  end
end
