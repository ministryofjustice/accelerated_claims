class Possession < BaseClass
  attr_accessor :hearing
  validates :hearing, presence: true, inclusion: { in: ['Yes', 'No'] }
end
