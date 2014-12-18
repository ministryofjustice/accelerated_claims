class UserCallback
  include ActiveModel::Model

  attr_accessor :name, :phone, :description

  NAME = 'Bob'
  PHONE = '020 7946 0708'
  DESCRIPTION = 'Show me things'

  @@phone_err_message = 'Please enter a valid phone number.'

  validates :name, presence: { message: 'Please enter a valid name.' }
  validates :phone, presence: { message: @@phone_err_message }
  validates :description, presence: { message: "Please describe what you'd like to talk about." }
  validate :phone_number_format

  def test?
    (name == NAME &&
     phone == PHONE &&
     description == DESCRIPTION) ? true : false
  end

  def error_messages
    errors.messages.each_with_object({}) do |parts, hash|
      field = parts.first
      message = parts.last
      hash["user_callback_#{field}_error"] = message
    end
  end

  private

  def phone_number_format
    errors.add(:phone, @@phone_err_message) if phone.gsub(/(-| )/, '').match(/\D/)
  end
end
