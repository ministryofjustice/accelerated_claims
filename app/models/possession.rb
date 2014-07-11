class Possession < BaseClass
  attr_accessor :hearing
  validates :hearing, presence: { message: 'You must choose whether you wish to attend the possible court hearing' }, inclusion: { in: ['Yes', 'No'] }
end
