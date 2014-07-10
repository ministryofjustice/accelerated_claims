class UserCallback
  include ActiveModel::Model

  attr_accessor :name, :phone, :description

  validates :name, :phone, :description, presence: true
  validate :phone_number_format

  private

  def phone_number_format
    phone.gsub(' ', '').match(/[-]?\d+/)
  end
end
