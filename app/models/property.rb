class Property
  include ActiveModel::Model

  attr_accessor :street
  validates :street, presence: true, length: { maximum: 70 }

  attr_accessor :town
  validates :town, length: { maximum: 40 }

  attr_accessor :postcode
  validates :postcode, presence: true, length: { maximum: 8 }

  attr_accessor :house
  validates :house, presence: true
end
