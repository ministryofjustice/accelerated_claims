require "spec_helper"

feature "New claim application" do

  def values_from_pdf file
    fields = `pdftk #{file} dump_data_fields`
    fields.strip.split('---').each_with_object({}) do |fieldset, hash|
      field = fieldset[/FieldName: ([^\s]+)/,1]
      value = fieldset[/FieldValue: ([^\s]+)/,1]
      hash[field] = value if field.present?
    end
  end

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
      check_order_possession_and_cost
      fill_court_fee
      click_button 'Complete form'

      expect(page).to have_text('You now need to send the completed form and documents to the court to make your claim')
      click_link 'Print completed form'
      expect(page.response_headers['Content-Type']).to eq "application/pdf"
      generated_file = '/tmp/a.pdf'
      File.open(generated_file, 'w') { |file| file.write(page.body.encode("ASCII-8BIT").force_encoding("UTF-8")) }
      pre_generated_pdf = File.join Rails.root, "./spec/support/filled-in-form.pdf"

      generated_values = values_from_pdf generated_file
      expected_values =  values_from_pdf pre_generated_pdf

      expected_values.each do |field, value|
        generated_values[field].should == value
      end

      generated_values["demoted_tenancy_demotion_order_date_day"].should == claim_post_data['claim']['demoted_tenancy']['demotion_order_date(3i)'].rjust(2, '0')
      generated_values["demoted_tenancy_demotion_order_date_month"].should == claim_post_data['claim']['demoted_tenancy']['demotion_order_date(2i)'].rjust(2, '0')
      generated_values["demoted_tenancy_demotion_order_date_year"].should == claim_post_data['claim']['demoted_tenancy']['demotion_order_date(1i)']
      generated_values['demoted_tenancy_demotion_order_court'].should == claim_post_data['claim']['demoted_tenancy']['demotion_order_court'].sub(' County Court','')
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
      fill_tenancy_reissued_no
      fill_notice
      fill_no_licence
      fill_no_deposit
      fill_no_postponement
      check_order_possession_only
      fill_court_fee
      click_button 'Complete form'
      expect(page).to have_text('You now need to send the completed form and documents to the court to make your claim')
    end
  end
end
