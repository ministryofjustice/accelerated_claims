require "spec_helper"

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
    def expected_values
      values = claim_formatted_data
      values['order_cost'] = 'Yes'
      values['demoted_tenancy_demoted_tenancy'] = 'No'
      values['tenancy_agreement_reissued_for_same_landlord_and_tenant'] = 'Yes'
      values['tenancy_agreement_reissued_for_same_property'] = 'Yes'
      values.delete_if{|k,v| k[/defendant_two/]}
      values
    end

    # given a set of valid data for two claimants
    # when I click 'print completed form'
    # it should return a PDF with the correct fields filled in
    scenario "fill in claim details" do
      @app = AppModel.new(claim_post_data)
      @app.claim_form.complete_form
      @app.claim_form.submit

      @app.confirmation_page.assert_is_displayed?

      filename = @app.confirmation_page.download_pdf
    end
  end

end
