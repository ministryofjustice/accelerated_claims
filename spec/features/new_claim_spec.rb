require "spec_helper"

feature "New claim application" do
  scenario "fill in property details" do
    visit '/new'
    fill_property_details
    fill_claimant_one
    fill_claimant_two
    fill_defendant_one
    fill_defendant_two
    fill_tenancy
    fill_notice
    fill_licences
    fill_deposit
    fill_postponement
    fill_order
    click_button 'Complete form'
    expect(page).to have_text('Your accelerated possession form is ready to print')
    click_link 'Print completed form'
    expect(page.response_headers['Content-Type']).to eq "application/pdf"
  end
end
