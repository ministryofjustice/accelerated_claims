feature 'Claimant' do

  before { WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/]) }

  def switch_between_landlord_types
    choose 'A private landlord (individual)'
    choose 'A private landlord (company), a local authority or a housing association'
    choose 'A private landlord (individual)'
    fill_in 'How many claimants are there?', with: '1'
  end

  def display_claimant_details_form_fields
    expect(page).to have_css('#claim_claimant_1_title')
  end

  scenario 'switching between landlord types', js: true do
    visit '/'
    switch_between_landlord_types
    display_claimant_details_form_fields
  end

  scenario 'choosing company hides claimant 1 label', js: true do
    visit '/'
    choose 'A private landlord (company), a local authority or a housing association'
    expect(page).not_to have_css('#claim_claimant_1_title')
  end
end
