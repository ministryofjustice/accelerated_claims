class Landlord
  include ActiveModel::Model

  attr_accessor :company
  validates :company, presence: true

  attr_accessor :street
  attr_accessor :town
  attr_accessor :postcode

end
