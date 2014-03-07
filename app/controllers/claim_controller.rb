class ClaimController < ApplicationController
 # after_filter :delete_all_pdfs, only: :submission

  def landing
    @page_title = 'Property possession'
    render 'landing'
  end

  def new
    @page_title = 'Property possession'
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
    @page_title = 'Property possession'
  end

  def download
    @claim = Claim.new(session[:claim])
    pdf = PDFDocument.new(@claim.as_json).fill
    send_file(pdf, filename: "accelerated-claim.pdf", disposition: "inline", type: "application/pdf")
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
