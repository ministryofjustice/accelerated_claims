#
# This is the superclass for ClaimantCollection and DefendantCollection
# it is an abstract class and cannot be instantiated.
# The subclasses must implement #participant_type()
#
class ParticipantCollection < BaseClass

  def initialize(claim_params)
    raise "Cannot instantiate Participant Collection: instantiate a subclass instead" if self.class == ParticipantCollection
    @errors = ActiveModel::Errors.new(self)
    @participants = {}
    @is_valid = nil
  end

  # returns the specified participant (note: index starts at 1 )
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

  # returns an array of participants indexed @first_extra_participant to @max_participants
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
    if @is_valid.nil?
      @participants.each do |index, participant|
        unless participant.valid?
          participant.errors.each do |field, msg|
            @errors.add("#{participant_type}_#{index}_#{field}".to_sym, msg)
          end
        end
      end
      @is_valid = @errors.empty?
    end
    @is_valid
  end

end