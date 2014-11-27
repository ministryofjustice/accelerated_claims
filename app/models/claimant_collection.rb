
class ClaimantCollection < ParticipantCollection

  MAX_CLAIMANTS = 4

  def initialize(claim_params)
    @num_participants = claim_params['num_claimants'].to_i || 0
    @claimant_type = claim_params['claimant_type']
    super
    validate_address_same_as_first_claimant = claim_params.key?('javascript_enabled')
    populate_claimants(claim_params, validate_address_same_as_first_claimant)
    @max_participants = MAX_CLAIMANTS
    @first_extra_participant = 3
  end

  def self.max_claimants
    MAX_CLAIMANTS
  end

  def self.participant_type
    'claimant'
  end

  def num_claimants
    @num_participants
  end

  private

  def populate_claimants(claim_params, validate_address_same_as_first_claimant)
    ( 1 .. ClaimantCollection.max_claimants ).each do |index|
      if claim_params.nil? || claim_params.empty?
        @participants[index] = Claimant.new( 'claimant_num' => index,
          'validate_address_same_as_first_claimant' => validate_address_same_as_first_claimant )
      else
        populate_claimant(index, claim_params, validate_address_same_as_first_claimant)
      end
    end
    populate_same_addresses
  end

  def populate_same_addresses
    first_claimant = @participants[1]
    @participants.select { |claimant_num, claimant| claimant.address_same_as_first_claimant == 'Yes'}.each do |claimant_num, claimant|
      claimant.street = first_claimant.street
      claimant.postcode = first_claimant.postcode
      claimant.address.suppress_validation!
    end
  end

  def populate_claimant(index, claim_params, validate_address_same_as_first_claimant)
    claimant_params = claim_params["claimant_#{index}"]
    claimant_params = ActiveSupport::HashWithIndifferentAccess.new if claimant_params.nil?
    claimant_params['claimant_type'] = @claimant_type
    claimant_params['num_claimants'] = @num_participants
    claimant_params['claimant_num'] = index
    if index > @num_participants
      claimant_params['validate_absence'] = true
      claimant_params['validate_presence'] = false
    else
      claimant_params['validate_presence'] = true
    end

    @participants[index] = Claimant.new( claimant_params.merge('validate_address_same_as_first_claimant' => validate_address_same_as_first_claimant) )
  end

end

