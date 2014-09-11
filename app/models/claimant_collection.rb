
class ClaimantCollection < ParticipantCollection

  MAX_CLAIMANTS = 4

  def initialize(claim_params)
    @num_participants = claim_params['num_claimants'].to_i || 0
    @claimant_type = claim_params['claimant_type']
    super
    populate_claimants(claim_params)
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

  def populate_claimants(claim_params)
    ( 1 .. ClaimantCollection.max_claimants ).each do |i|
      if claim_params.nil? || claim_params.empty?
        @participants[i] = Claimant.new( 'claimant_num' => index )
      else
        populate_claimant(index, claim_params)
      end
    end
  end

  def populate_claimant(index, claim_params)
    claimant_params = claim_params["claimant_#{index}"]
    claimant_params = ActiveSupport::HashWithIndifferentAccess.new if claimant_params.nil?
    claimant_params['claimant_type'] = @claimant_type
    claimant_params['claimant_num'] = index
    if index > @num_participants
      claimant_params['validate_absence'] = true
      claimant_params['validate_presence'] = false
    else
      claimant_params['validate_presence'] = true
    end

    @participants[index] = Claimant.new(claimant_params)
  end

end
