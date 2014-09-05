
# This is the superclass for ClaimantCollection and DefendantCollection
# it is an abstract class and cannot be instantiated.
# The subclasses must implement #participant_type()
#


class ParticipantCollection < BaseClass

  

  def initialize(claim_params)
    raise "Cannot instantiate Participant Collection: instantiate a subclass instead" if self.class == ParticipantCollection
    @errors = ActiveModel::Errors.new(self)
    @participants = {}
  end



  # returns the specified claimant (note: index starts at 1 )         
  def [](index)
    participants = @participants[index]
    raise ArgumentError.new "No such index: #{index}" if index == 0
    participants
  end

  def []=(index, participants)
    raise ArgumentError.new "Invalid index: #{index}" if index == 0
    raise ArgumentError.new "Invalid index: #{index}" if index > @num_participants
    @participants[index] = participants
  end

  def size
    @num_participants
  end


  # returns an array of claimants 2 to 4
  def further_participants
    arr = []
    (@first_extra_participant .. @max_participants).each do |i|
      arr << self[i] unless self[i].empty?
    end
    arr
  end




  # returns the participant type as defined in the sub-class
  def participant_type
    self.class.participant_type
  end


  def as_json
    hash = {}
    (1 .. @num_participants).each do |index|
      hash["#{participant_type}_#{index}"] = @participants[index]
    end
    hash.as_json
  end


  def valid?
    @participants.each do |index, participant| 
      unless participant.valid?
        participant.errors.each do |field, msg|
          @errors.add("#{participant_type}_#{index}_#{field}".to_sym, msg)
        end
      end
    end
    @errors.empty? ? true : false
  end
 


  
end