class Court < BaseClass

  attr_accessor :court_name
  validates :court_name, presence: { message: 'You must provide court name' }

  attr_accessor :street
  validates :street, presence: { message: 'You must provide court address' }

  attr_accessor :postcode
  validates :postcode, presence: { message: 'You must provide the postcode for the court' }

  def as_json
    {
      'name' => court_name,
      'address' => "#{court_name}\n#{street}\n#{postcode}".sub(', ', "\n")
    }
  end
end
