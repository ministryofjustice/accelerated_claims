
feature 'Claimant number selection' do

  before { WebMock.disable_net_connect!(:allow => "127.0.0.1") }

  scenario 'when nothing on the page is selected', js: true do
    visit '/'
    text = 'If you want us to send correspondence about the case to a different address, enter it here'
    expect(page).not_to have_content(text)
  end

  context 'when individual landlord' do

    describe 'when number of claimants' do
      scenario 'are not selected', js: true do
        visit '/'
        choose 'A private landlord (individual)'
        expect(page).not_to have_css('#claim_claimant_1_street')
      end

      scenario 'are selected', js: true do
        visit '/'
        choose 'A private landlord (individual)'
        fill_in "How many claimants are there?", with: '1'
        expect(page).to have_css('.claimant-solicitor')
      end
    end
  end

  context 'when company' do
    scenario 'additional contact info', js: true do
      visit '/'
      choose 'A private landlord (company), a local authority or a housing association'
      expect(page).to have_css('.claimant-solicitor')
    end

    scenario 'claimant type change', js: true do
      visit '/'
      choose 'A private landlord (company), a local authority or a housing association'
      choose 'A private landlord (individual)'
      expect(page).not_to have_css('#claim_claimant_1_street')
    end
  end
end
