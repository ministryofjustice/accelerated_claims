class UserCallback
  include ActiveModel::Model

  attr_accessor :name, :phone, :description

  NAME = 'Bob'
  PHONE = '020 7946 0708'
  DESCRIPTION = 'Show me things'

  validates :name, :phone, :description, presence: true
  validate :phone_number_format

  def test?
    (name == NAME &&
     phone == PHONE &&
     description == DESCRIPTION) ? true : false
  end

  private

  def phone_number_format
    phone.gsub(' ', '').match(/[-]?\d+/)
  end
end
