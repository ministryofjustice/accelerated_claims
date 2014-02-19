class ClaimController < ApplicationController
 # after_filter :delete_all_pdfs, only: :submission

  def new
    @page_title = 'Property repossession'
    @date_select_options = {
      order: [:day, :month, :year],
      with_css_classes: true,
      prompt: { day: 'Day', month: 'Month', year: 'Year' },
      start_year: Date.today.year,
      end_year: Date.today.year - 30
    }
    if(c = session[:claim])
      @claim = Claim.new(c)
      @errors = @claim.errors unless @claim.valid?
    else
      @claim = Claim.new
    end
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
    session[:claim] = params['claim']
    @claim = Claim.new(params['claim'])
    unless @claim.valid?
      redirect_to :new
    else
      redirect_to :confirmation
    end
  end

  private

  def delete_all_pdfs
    FileUtils.rm Dir.glob('/tmp/*pdf')
  end
end
