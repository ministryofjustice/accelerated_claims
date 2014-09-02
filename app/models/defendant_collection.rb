class DefendantCollection < ParticipantCollection


  MAX_DEFENDANTS = 20

  def initialize(claim_params)
    @num_participants = claim_params['num_defendants'].to_i || 0
    super
    populate_defendants(claim_params)
  end
  



  def self.max_defendants
    MAX_DEFENDANTS
  end

  def self.participant_type
    'defendant'
  end


  def num_defendants
    @num_participants
  end





  private

  def populate_defendants(claim_params)
    cache_defendant_1_address
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
    copy_cached_defendant_1_address(defendant_params) if defendant_params['inhabits_property'].try(:downcase) == 'yes'


    # we need to populate the defendant with the params even if > thn number of defendants!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    if index > num_defendants
      defendant_params['validate_absence'] = true 
      defendant_params['validate_presence'] = false
    else
      defendant_params['validate_presence'] = true 
    end
    @participants[index] = Defendant.new(defendant_params)
  end
  

  def cache_defendant_1_address
    if claim_params['defendant_1'].nil?
      @cached_defendant_1_street = ''
      @cached_defendant_1_postcode = ''
    else
      @cached_defendant_1_street = claim_params['defendant_1']['street']
      @cached_defendant_1_postcode = claim_params['defendant_1']['postcode']
    end
  end


  def copy_cached_defendant_1_address(params)
    params['street'] = @cached_defendant_1_street
    params['postcode'] = @cached_defendant_1_postcode
  end




end