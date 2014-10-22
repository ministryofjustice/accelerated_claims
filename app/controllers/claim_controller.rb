class ClaimController < ApplicationController

  # set the live_postcode_lookup flag as a class variable so that it can be queried from the PostcodeLookupProxyController
  @@live_postcode_lookup = false


  def self.live_postcode_lookup?
    @@live_postcode_lookup
  end

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


    # use live postcode lookup database if running on productionserver or url param livepc set to 1

    Rails.logger.info ">>>>>>>>> ENV['ENV_NAME']:  #{ENV['ENV_NAME']}"


    production = ENV["ENV_NAME"] == "production"
    Rails.logger.info ">>>>>>>>> production: #{production.inspect}"
    if production == true || params[:livepc] == '1'
      Rails.logger.info ">>>>>>>>> setting live postcode lookup to true"
      @@live_postcode_lookup = true
    else
      Rails.logger.info ">>>>>>>>> setting live postcode lookup to false"
      @@live_postcode_lookup = false
    end


    @claim = if !production && params.has_key?(:journey)
      force_reload = params.has_key?(:reload)

      require 'fixture_data'
      journey_id = params[:journey].to_i
      claim_data = FixtureData.data(force_reload).params_data_for(journey_id)
      Claim.new(HashWithIndifferentAccess.new(claim_data))
    elsif (data = session[:claim])
      Claim.new(data).tap { |claim|
        @errors = claim.errors unless claim.valid?
      }
    else
      Claim.new
    end
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
    move_claimant_address_params_into_the_model
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


  def move_claimant_address_params_into_the_model
    (2 .. ClaimantCollection.max_claimants).each do |i|
      key = "claimant#{i}address"
      if params.key?(key) && params[key] == "yes"
        params['claim']["claimant_#{i}"]['street'] = params['claim']['claimant_1']['street']
        params['claim']["claimant_#{i}"]['postcode'] = params['claim']['claimant_1']['postcode']
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
