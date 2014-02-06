class Tenant < BaseClass

  attr_accessor :title
  validates :title, presence: true, length: { maximum: 8 }
  attr_accessor :full_name
  attr_accessor :street
  attr_accessor :town
  attr_accessor :postcode
end
