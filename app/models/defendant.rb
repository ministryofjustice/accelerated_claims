class Defendant
  include ActiveModel::Model

  attr_accessor :hearing
  validates :hearing, inclusion: { in: [true, false] }
end
