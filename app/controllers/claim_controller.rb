class ClaimController < ApplicationController

  before_filter :set_production_status

  def new
    reset_session if referrer_is_landing_page?
    session[:test] = params[:test]

    @page_title = 'Make a claim to evict tenants: accelerated possession'

    @date_select_options = get_date_select_options

    @claim =
        if has_journey
          get_claim_for_journey
        elsif session[:claim]
          get_claim_from_session
        else
          Claim.new
        end
  end

  def confirmation
    @claim = session[:claim]

    return redirect_to_with_protocol(:new) if @claim.nil?

    claim_object = Claim.new(@claim)

    if claim_object.valid?
      update_defendant_inhabits(claim_object)
      @claim['fee']['account'] = claim_object.fee.account # set zero-padded account number
      @claim = SummaryHashCleaner.new(@claim).clean
      @page_title = 'Make a claim to evict tenants: accelerated possession'
    else
      redirect_to_with_protocol(:new)
    end

    @claim = PostcodeNormalizer.new(@claim).normalize
  end

  def download
    return redirect_to expired_path if session[:claim].nil?

    @claim = Claim.new(session[:claim])

    return redirect_to_with_protocol :new if !@claim.valid?

    log_fee_account_num_usage

    flatten = in_test_or_flatten
    pdf = PDFDocument.new(@claim.as_json, flatten).fill

    send_pdf(pdf)
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
    params['claim']['use_live_postcode_lookup'] = @use_live_postcode_lookup
    session[:claim] = params['claim']

    move_claimant_address_params_into_model
    move_defendant_address_params_into_model

    @claim = get_claim_from_params

    if @claim.valid?
      redirect_to_with_protocol :confirmation
    else
      redirect_to_with_protocol :new
    end
  end

  def raise_exception
    session[:special_values] = "session variable"
    raise "This exception has been deliberately raised"
  end

  private

  def get_claim_for_journey
    force_reload = params.has_key?(:reload)
    require 'fixture_data'
    journey_id = params[:journey].to_i
    claim_data = FixtureData.data(force_reload).params_data_for(journey_id)
    Claim.new(HashWithIndifferentAccess.new(claim_data))
  end

  def get_claim_from_session
    Claim.new(session[:claim]).tap do |claim|
      unless claim.valid?
        @errors = claim.errors
        @error_messages = claim.error_messages
      end
    end
  end

  def get_claim_from_params
    Claim.new(params['claim'])
  end

  def get_date_select_options
    {
      order: [:day, :month, :year],
      with_css_classes: true,
      prompt: { day: 'Day', month: 'Month', year: 'Year' },
      start_year: Date.today.year,
      end_year: Tenancy::APPLICABLE_FROM_DATE.year
    }
  end

  def has_journey
    !@production && params.has_key?(:journey)
  end

  def in_test_or_flatten
    Rails.env.test? || params[:flatten] == 'false' ? false : true
  end

  # only record a fee_account_num event if the property postcode is NOT the same as the previous download in this session
  def log_fee_account_num_usage
    if check_for_session_fee_account
      LogStuff.info(:fee_account_num,
                    present: @claim.fee.account.present?.to_s,
                    ip: request.remote_ip) { 'Fee Account Number Usage' }
      set_postcode_from_session
    end
  end

  def set_postcode_from_session
    session[:fee_account_num_logged] = session[:claim][:property][:postcode]
  end

  def check_for_session_fee_account
    session[:fee_account_num_logged].nil? || session_fa_equals_postcode
  end

  def session_fa_equals_postcode
    (session[:fee_account_num_logged] != session[:claim][:property][:postcode])
  end

  def set_production_status
    # set production to true if on production or staging - this is used to determine whether or not journey numbers are valid in the url
    @production = ['staging', 'production'].include?(ENV['ENV_NAME'])
    request_referrer_query_string = get_request_referrer
    @use_live_postcode_lookup = use_live_pc(request_referrer_query_string)
  end

  def use_live_pc(request)
    @production || params[:livepc] == '1' || request == 'livepc=1'
  end

  def get_request_referrer
    request.referrer ? URI(request.referrer).query : nil
  end

  def move_defendant_address_params_into_model
    nums = { '1' => 'one', '2' => 'two' }
    nums.each do |n, n_as_str|
      key = "defendant#{n}address"
      if params.key?(key)
        params['claim']["defendant_#{n_as_str}"]['property_address'] = params[key]
      end
    end
  end

  def move_claimant_address_params_into_model
    (2 .. ClaimantCollection.max_claimants).each do |i|
      claim_key = "claimant_#{i}"
      key = "claimant#{i}address"
      if key_present_and_yes(key)
        update_claimant_address(claim_key)
      end
    end
  end

  def update_claimant_address(claim_key)
    update_address_param claim_key, 'street'
    update_address_param claim_key, 'postcode'
  end

  def update_address_param(claim_key, key)
    params['claim'][claim_key][key] = params['claim']['claimant_1'][key]
  end

  def update_defendant_inhabits(claim_object)
    (1..claim_object.num_defendants).each do |i|
      @claim["defendant_#{i}"]['inhabits_property'] = claim_object.defendants[i].inhabits_property
    end
  end

  def key_present_and_yes(key)
    params.key?(key) && params[key] == 'yes'
  end

  def send_pdf(pdf)
    ActiveSupport::Notifications.instrument('send_file') do
      send_file(pdf.path, filename: 'accelerated-claim.pdf', disposition: 'inline', type: 'application/pdf')
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
