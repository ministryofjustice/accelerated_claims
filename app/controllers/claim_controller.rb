class ClaimController < ApplicationController
 # after_filter :delete_all_pdfs, only: :submission

  def landing
    @page_title = 'Property possession'
    render 'landing'
  end

  def new
    reset_session if referrer_is_landing_page?

    @page_title = 'Property possession'
    @date_select_options = {
      order: [:day, :month, :year],
      with_css_classes: true,
      prompt: { day: 'Day', month: 'Month', year: 'Year' },
      start_year: Date.today.year,
      end_year: Date.today.year - 30
    }
    if(data = session[:claim])
      @claim = Claim.new(data)
      @errors = @claim.errors unless @claim.valid?
    else
      @claim = Claim.new
    end
  end

  def confirmation
    claim = session[:claim]
    unless (!claim.nil? && Claim.new(claim).valid?)
      redirect_to_with_protocol(:new)
    end

    @page_title = 'Property possession'
  end

  def download
    @claim = Claim.new(session[:claim])

    if @claim.valid?
      pdf = PDFDocument.new(@claim.as_json).fill
      send_file(pdf, filename: "accelerated-claim.pdf", disposition: "inline", type: "application/pdf")
    else
      redirect_to_with_protocol :new
    end
  end

  def submission
    session[:claim] = params['claim']
    @claim = Claim.new(params['claim'])

    unless @claim.valid?
      redirect_to_with_protocol :new
    else
      redirect_to_with_protocol :confirmation
    end
  end

  private

  def delete_all_pdfs
    FileUtils.rm Dir.glob('/tmp/*pdf')
  end

  def referrer_is_landing_page?
    referrer = request.referrer
    if referrer.present?
      URI.parse(referrer).path == url_root
    else
      false
    end
  end

  def url_root
    config.relative_url_root.present? ? config.relative_url_root : '/'
  end
end
