feature 'Claimant' do

  before { WebMock.disable_net_connect!(:allow => "127.0.0.1") }

  scenario '', js: true do
    visit '/'
    choose 'A private landlord (individual)'
    choose '1 claimant'
    choose 'A private landlord (company), a local authority or a housing association'
    choose 'A private landlord (individual)'
    expect(page).to have_css('#claim_claimant_one_title')
  end
end
