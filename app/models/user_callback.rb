class UserCallback
  include ActiveModel::Model

  attr_accessor :name, :phone, :description

  validates :name, :phone, :description, presence: true
  validate :phone_number_format

  def test?
    (name == 'Bob' &&
     phone == '020 7946 0708' &&
     description == 'Show me things') ? true : false
  end

  private

  def phone_number_format
    phone.gsub(' ', '').match(/[-]?\d+/)
  end
end
