class Court < BaseClass

  attr_accessor :court_name, :address

  validate  :address_validation
  validates :court_name, presence: { message: 'You must enter the court’s name' }

  delegate :street, :street=, :postcode, :postcode=, to: :address

  def initialize(params = {})
    @address = Address.new(self)
    @address.england_and_wales_only!
    super
  end

  def address_validation
    @address.valid?
  end

  attr_accessor :default

  def as_json
    {
      'name' => court_name,
      'address' => "#{court_name}\n#{street}\n#{postcode}".sub(',', "\n")
    }
  end
end
