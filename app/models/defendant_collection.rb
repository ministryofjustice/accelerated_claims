class DefendantCollection < ParticipantCollection

  MAX_DEFENDANTS_JS_ENABLED   = 20
  MAX_DEFENDANTS_JS_DISABLED  = 4

  attr_reader

  def initialize(claim_params)
    @num_participants  = claim_params['num_defendants'].to_i || 0
    @property_street   = ''
    @property_postcode = ''
    super
    populate_defendants(claim_params)
    @first_extra_participant = 1
    @max_participants = MAX_DEFENDANTS_JS_ENABLED
  end

  def self.max_defendants(options = {:js_enabled => true})
    options[:js_enabled] == true ? MAX_DEFENDANTS_JS_ENABLED : MAX_DEFENDANTS_JS_DISABLED
  end

  def self.participant_type
    'defendant'
  end

  def num_defendants
    @num_participants
  end

  private

  def populate_defendants(claim_params)
    cache_property_address(claim_params)
    if claim_params.nil? || claim_params.empty?
      ( 1 .. DefendantCollection.max_defendants ).each { |i|  @participants[i] = Defendant.new }
    else
      ( 1 .. DefendantCollection.max_defendants ).each { | i | populate_defendant(i, claim_params) }
    end
  end

  # we want to iterate through this until max-num-claimants.

  # for all those <= num_claimants, we wantto ensure data is there
  # for those above, we want to ensure data is not there, and not add the claimant in if its' not there.

  def populate_defendant(index, claim_params)
    defendant_params = claim_params["defendant_#{index}"]
    defendant_params = ActiveSupport::HashWithIndifferentAccess.new if defendant_params.nil?
    defendant_params['defendant_num'] = index

    # we need to populate the defendant with the params even if > than number of defendants so that we can re-display that data on the error page
    if index > num_defendants
      defendant_params['validate_absence'] = true
      defendant_params['validate_presence'] = false
    else
      defendant_params['validate_presence'] = true
    end
    copy_cached_property_address_if_blank(defendant_params)
    @defendant = Defendant.new(defendant_params)
    if @defendant.validate_presence
      @defendant.inhabits_property = @defendant.street == @property_street && @defendant.postcode == @property_postcode ? 'yes' : 'no'
    else
      @defendant.inhabits_property=nil
    end
    @participants[index] = @defendant
  end

  def cache_property_address(claim_params)
    unless claim_params['property'].blank?
      @property_street   = claim_params['property']['street']
      @property_postcode = claim_params['property']['postcode']
    end
  end

  def copy_cached_property_address_if_blank(params)
    if params['validate_presence'] && params['street'].blank? && params['postcode'].blank?
      params['street']   = @property_street
      params['postcode'] = @property_postcode
    end
  end
end
