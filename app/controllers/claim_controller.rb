class ClaimController < ApplicationController

  def new
    reset_session if referrer_is_landing_page?
    session[:test] = params[:test]

    @page_title = 'Make a claim to evict tenants: accelerated possession'

    @date_select_options = {
      order: [:day, :month, :year],
      with_css_classes: true,
      prompt: { day: 'Day', month: 'Month', year: 'Year' },
      start_year: Date.today.year,
      end_year: Tenancy::APPLICABLE_FROM_DATE.year
    }
    if session && session[:claim]
      puts "++++++ DEBUG claim controller new session[:claim][:num_claimants]   #{session[:claim][:num_claimants]}  ++++++ #{__FILE__}::#{__LINE__} ++++\n"
      puts "++++++ DEBUG claim controller new session[:claim]['num_claimants']  #{session[:claim]['num_claimants']}  ++++++ #{__FILE__}::#{__LINE__} ++++\n"
    end


    if(data = session[:claim])
      @claim = Claim.new(data)

      @errors = @claim.errors unless @claim.valid?
    else
      @claim = Claim.new
    end
    puts "++++++ DEBUG end of ClaimController.new  claim.num_claimants #{@claim.num_claimants.inspect} ++++++ #{__FILE__}::#{__LINE__} ++++\n"
    
  end

  def confirmation
    claim = session[:claim]

    if claim.nil? || !Claim.new(claim).valid?
      redirect_to_with_protocol(:new)
    end

    @page_title = 'Make a claim to evict tenants: accelerated possession'
  end

  def download
    if session[:claim].nil?
      msg = "User attepmted to download PDF from an expired session - redirected to #{expired_path}"
      Rails.logger.warn msg
      redirect_to expired_path
    else
      @claim = Claim.new(session[:claim])

      if @claim.valid?
        flatten = Rails.env.test? || params[:flatten] == 'false' ? false : true
        pdf = PDFDocument.new(@claim.as_json, flatten).fill

        ActiveSupport::Notifications.instrument('send_file') do
          send_file(pdf.path, filename: "accelerated-claim.pdf", disposition: "inline", type: "application/pdf")
        end
      else
        redirect_to_with_protocol :new
      end
    end
  end

  # Returns JSON formatted data which is passed for PDF generation.
  def data
    @claim = Claim.new(session[:claim])

    if @claim.valid?
      pdf = PDFDocument.new(@claim.as_json)
      render json: pdf.json
    else
      redirect_to_with_protocol :new
    end
  end

  def submission
    session[:claim] = params['claim']
    move_defendant_address_params_into_model
    @claim = Claim.new(params['claim'])

    unless @claim.valid?
      redirect_to_with_protocol :new
    else
      redirect_to_with_protocol :confirmation
    end
  end

  def raise_exception
    session[:special_values] = "session variable"
    raise "This exception has been deliberately raised"
  end

  private

  def move_defendant_address_params_into_model
    nums = { '1' => 'one', '2' => 'two' }
    nums.each do |n, n_as_str|
      key = "defendant#{n}address"
      if params.key?(key)
        params['claim']["defendant_#{n_as_str}"]['property_address'] = params[key]
      end
    end
  end

  def delete_all_pdfs
    FileUtils.rm Dir.glob('/tmp/*pdf')
  end

  def referrer_is_landing_page?
    referrer = request.referrer
    if referrer.present?
      referrer == 'https://www.gov.uk/accelerated-possession-eviction'
    else
      false
    end
  end

  def url_root
    config.relative_url_root.present? ? config.relative_url_root : '/'
  end
end
