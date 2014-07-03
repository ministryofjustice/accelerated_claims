class Contact
  include ActiveModel::Model

  attr_accessor :name, :phone, :description

  validates :name, :phone, :description, presence: true
end
