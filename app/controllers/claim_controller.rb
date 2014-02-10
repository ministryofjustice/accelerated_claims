class ClaimController < ApplicationController
  after_filter :delete_all_pdfs, only: :submission

  def new
    @page_title = 'Property repossession'
    @claim = Claim.new
    @property = Property.new
    @landlord = Landlord.new
    @tenant_one = Tenant.new
    @tenant_two = Tenant.new
    @demoted_tenancy = DemotedTenancy.new
    @notice = Notice.new
    @license = License.new
    @deposit = Deposit.new
    @defendant = Defendant.new
    @order = Order.new
  end

  def submission
    begin
      template = File.join Rails.root, "templates", "form.pdf"
      result = Tempfile.new('form', tmpdir: '/tmp/')
      pdf = PdfForms.new(ENV["PDFTK"])
      pdf.fill_form template, result, "ClaimantNameAddress1" => params["claim"]["landlord"]["company"]
      send_file(result.path, filename: "accelerated-claim.pdf", disposition: "inline", type: "application/pdf")
    ensure
      result.close
    end
  end

  private

  def delete_all_pdfs
    FileUtils.rm Dir.glob('/tmp/*pdf')
  end
end
