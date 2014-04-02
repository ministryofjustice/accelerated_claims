feature "New claim application" do
  def values_from_pdf file
    fields = `pdftk #{file} dump_data_fields`
    fields.strip.split('---').each_with_object({}) do |fieldset, hash|
      field = fieldset[/FieldName: ([^\s]+)/,1]
      value = fieldset[/FieldValue: (.+)/,1]
      value.gsub!('&#13;',"\n") if value.present?
      hash[field] = value if field.present?
    end
  end

  context "with two claimants" do
    scenario "fill in claim details, without demoted tenancy" do
      def expected_values
        values = claim_formatted_data
        values['order_cost'] = 'Yes'
        values['demoted_tenancy_demoted_tenancy'] = 'No'
        values['demoted_tenancy_demotion_order_date_day'] = ''
        values['demoted_tenancy_demotion_order_date_month'] = ''
        values['demoted_tenancy_demotion_order_date_year'] = ''
        values['demoted_tenancy_demotion_order_court'] = ''
        values['tenancy_agreement_reissued_for_same_landlord_and_tenant'] = 'Yes'
        values['tenancy_agreement_reissued_for_same_property'] = 'Yes'
        values.delete_if { |k,v| k[/defendant_two/] }
        values
      end

      visit '/new'
      fill_property_details
      fill_claimant_one
      fill_claimant_solicitor_address
      fill_claimant_contact_details
      fill_claimant_two
      fill_defendant_one
      fill_solicitor_cost
      fill_non_demoted_tenancy
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

      generated_values = values_from_pdf generated_file

      expected_values.each do |field, value|
        "#{field}: #{generated_values[field]}".should == "#{field}: #{value}"
      end
    end

    scenario "fill in claim details, with demoted tenancy" do
      def expected_values
        values = claim_formatted_data
        values['order_cost'] = 'Yes'
        values['tenancy_agreement_reissued_for_same_landlord_and_tenant'] = ''
        values['tenancy_agreement_reissued_for_same_property'] = ''
        values.delete_if { |k,v| k[/defendant_two/] }
        values
      end

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

      generated_values = values_from_pdf generated_file

      expected_values.each do |field, value|
        "#{field}: #{generated_values[field]}".should == "#{field}: #{value}"
      end

      demoted_tenancy_check(generated_values)
    end
  end

  context 'with one claimant and one defendant' do
    scenario "fill in claim details" do
      visit '/new'
      fill_property_details
      fill_claimant_one
      fill_defendant_one
      fill_non_demoted_tenancy
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
