class ClaimController < ApplicationController
 # after_filter :delete_all_pdfs, only: :submission

  def new
    @page_title = 'Property repossession'
    @claim = Claim.new
  end

  def confirmation
  end

  def download
    @claim = Claim.new(session[:claim])
    begin
      template = File.join Rails.root, "templates", "form.pdf"
      result = Tempfile.new('accelerated_claim', tmpdir: '/tmp/')
      pdf = PdfForms.new(ENV["PDFTK"])
      pdf.fill_form template, result, @claim.as_json
      send_file(result.path, filename: "accelerated-claim.pdf", disposition: "inline", type: "application/pdf")
    ensure
      result.close
    end
  end

  def submission
    session[:claim] = params["claim"]
    # unless @claim.valid?
    #   @errors = @claim.errors
    #   render 'new'
    # else

    # end
    redirect_to :confirmation
  end

  private

  def delete_all_pdfs
    FileUtils.rm Dir.glob('/tmp/*pdf')
  end
end
