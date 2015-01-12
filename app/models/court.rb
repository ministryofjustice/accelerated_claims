class Court < BaseClass

  attr_accessor :court_name, :address

  validate  :address_validation

  delegate :street, :street=, :postcode, :postcode=, to: :address

  def initialize(params = {})
    @address = Address.new(self)
    super
  end

  def address_validation
    @address.valid?
  end

  def as_json
    {
      'name' => court_name,
      'address' => "#{court_name}\n#{street}\n#{postcode}".sub(',', "\n")
    }
  end
end
