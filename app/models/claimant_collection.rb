
class ClaimantCollection < ParticipantCollection


  MAX_CLAIMANTS = 4

  def initialize(claim_params)
    
    @num_participants = claim_params['num_claimants'].to_i || 0
    @claimant_type = claim_params['claimant_type']
    super
    populate_claimants(claim_params)
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


  def valid?
    @claimants.each do |index, claimant| 
      unless claimant.valid?
        claimant.errors.each do |field, msg|
          @errors.add("claimant_#{index}_#{field}".to_sym, msg)
        end
      end
    end
    @errors.empty? ? true : false
  end


  private

  def populate_claimants(claim_params)
    if claim_params.nil? || claim_params.empty?
      ( 1 .. ClaimantCollection.max_claimants ).each { |i|  @participants[i] = Claimant.new }
    else
      ( 1 .. ClaimantCollection.max_claimants ).each { | i | populate_claimant(i, claim_params) }
    end
  end



  # we want to iterate through this until max-num-claimants.

  # for all those <= num_claimants, we wantto ensure data is there
  # for those above, we want to ensure data is not there, and not add the claimant in if its' not there.


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
