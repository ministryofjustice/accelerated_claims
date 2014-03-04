require 'uk_postcode'

module Address

  extend ActiveSupport::Concern

  included do
    attr_accessor :street
    attr_accessor :town
    attr_accessor :postcode

    validates :street,   length: { maximum: 70 }
    validates :town,     length: { maximum: 40 }
    validates :postcode, length: { maximum: 8 }

    validate :full_postcode
  end

  def full_postcode
    if postcode.present?
      if !UKPostcode.new(postcode).valid?
        errors.add(:postcode, "not valid postcode")
      elsif !UKPostcode.new(postcode).full?
        errors.add(:postcode, "not full postcode")
      end
    end
  end

end
