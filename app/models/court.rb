class Court < BaseClass

  attr_accessor :court_name
  validates :court_name, presence: { message: 'You must provide court name' }

  attr_accessor :address
  validates :address, presence: { message: 'You must provide court address' }

  attr_accessor :town
  validates :town, presence: { message: 'You must provide the town for the court' }

  attr_accessor :postcode
  validates :postcode, presence: { message: 'You must provide the postcode for the court' }

end
