
class ClaimantCollection < BaseClass


  MAX_CLAIMANTS = 4

  def initialize(claim_params)
    @errors = ActiveModel::Errors.new(self)
    @num_claimants = claim_params['num_claimants'].to_i || 0
    @claimants = {}
    @claimant_type = claim_params['claimant_type']
    populate_claimants(claim_params)
  end



  # returns the specified claimant (note: index starts at 1 )         
  def [](index)
    claimant = @claimants[index]
    raise ArgumentError.new "No such index: #{index}" if index == 0
    claimant
  end

  def []=(index, claimant)
    raise ArgumentError.new "Invalid index: #{index}" if index == 0
    raise ArgumentError.new "Invalid index: #{index}" if index > @num_claimants
    @claimants[index] = claimant
  end

  def size
    @num_claimants
  end

  # returns a hash of claimants and models used in Claim#attributes_from_submodels
  def model_hash
    hash = {}
    (1..@num_claimants).each { |i|  hash["claimant_#{i}"] = 'Claimant' }
    hash
  end


  def as_json
    hash = {}
    (1 .. @num_claimants).each do |index|
      hash["claimant_#{index}"] = @claimants[index]
    end
    hash.as_json
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
      ( 1 .. MAX_CLAIMANTS ).each { |i|  @claimants[i] = Claimant.new }
    else
      ( 1 .. MAX_CLAIMANTS ).each { | i | populate_claimant(i, claim_params) }
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
    if index > @num_claimants
      claimant_params['validate_absence'] = true 
      claimant_params['validate_presence'] = false
    else
      claimant_params['validate_presence'] = true 
    end
    @claimants[index] = Claimant.new(claimant_params)
  end
  


end