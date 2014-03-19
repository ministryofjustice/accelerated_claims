require "spec_helper"

feature "New claim application" do
  context "with two claimants" do
    scenario "fill in claim details" do
      visit '/new'
      fill_property_details
      fill_claimant_one
      fill_claimant_solicitor_address
      fill_claimant_contact_details
      fill_claimant_two
      fill_defendant_one
      fill_solicitor_cost
      fill_demoted_tenancy
      fill_tenancy
      fill_notice
      fill_licences
      fill_deposit
      fill_postponement
      fill_order
      fill_court_fee
      click_button 'Complete form'

      expect(page).to have_text('You now need to send the completed form and documents to the court to make your claim')
      click_link 'Print completed form'
      expect(page.response_headers['Content-Type']).to eq "application/pdf"
      generated_file = '/tmp/a.pdf'
      File.open(generated_file, 'w') { |file| file.write(page.body.encode("ASCII-8BIT").force_encoding("UTF-8")) }
      pre_generated_pdf = File.join Rails.root, "./spec/support/filled-in-form.pdf"
      diff_pdfs(pre_generated_pdf, generated_file).should be_blank
    end
  end

  context 'with one claimant and one defendant' do
    scenario "fill in claim details" do
      visit '/new'
      fill_property_details
      fill_claimant_one
      fill_defendant_one
      fill_demoted_tenancy
      fill_tenancy
      fill_notice
      fill_no_licence
      fill_deposit
      fill_postponement
      fill_order
      fill_court_fee
      click_button 'Complete form'
      expect(page).to have_text('You now need to send the completed form and documents to the court to make your claim')
    end
  end
end
