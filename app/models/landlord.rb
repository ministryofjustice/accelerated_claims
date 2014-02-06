class Landlord
  include ActiveModel::Model

  attr_accessor :company
  validates :company, presence: true

  attr_accessor :street
  validates :street, length: { maximum: 40 }

  attr_accessor :town
  attr_accessor :postcode

end
