feature 'Claimant' do

  before { WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/]) }

  def switch_between_landlord_types
    choose 'A private landlord (individual)'
    choose '1 claimant'
    choose 'A private landlord (company), a local authority or a housing association'
    choose 'A private landlord (individual)'
  end

  def display_claimant_details_form_fields
    expect(page).to have_css('#claim_claimant_one_title')
  end

  scenario 'switching between landlord types', js: true do
    visit '/'
    switch_between_landlord_types
    display_claimant_details_form_fields
  end
end
