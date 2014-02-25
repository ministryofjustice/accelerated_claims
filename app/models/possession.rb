class Possession < BaseClass
  attr_accessor :hearing
  validates :hearing, presence: { message: 'must be selected' }, inclusion: { in: ['Yes', 'No'] }
end
