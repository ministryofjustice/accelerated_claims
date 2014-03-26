require "spec_helper"

feature "New claim application" do

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
      data = load_fixture_data(1)
      @app = AppModel.new(data)
      @app.claim_form.complete_form
      @app.claim_form.submit

      @app.confirmation_page.is_displayed?.should be_true

      filename = @app.confirmation_page.download_pdf
    end
  end

end
