class Possession < BaseClass
  attr_accessor :hearing
  validates :hearing, inclusion: { in: ['Yes', 'No'] }
end
