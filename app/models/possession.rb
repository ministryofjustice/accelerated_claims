class Possession < BaseClass
  attr_accessor :hearing
  validates :hearing, inclusion: { in: [true, false] }
end
