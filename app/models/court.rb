class Court < BaseClass

  attr_accessor :court_name
  validates :court_name, presence: { message: 'You must enter the court’s name' }

  attr_accessor :street
  validates :street, presence: { message: 'You must enter the court’s address' }

  attr_accessor :postcode
  validates :postcode, presence: { message: 'You must enter the court’s postcode' }

  attr_accessor :default

  def as_json
    {
      'name' => court_name,
      'address' => "#{court_name}\n#{street}\n#{postcode}".sub(',', "\n")
    }
  end
end
