require 'uk_postcode'

module Address

  extend ActiveSupport::Concern

  included do
    attr_accessor :street
    attr_accessor :postcode

    validates :street,   length: { maximum: 70 }
    validates :postcode, length: { maximum: 8 }

    validate :full_postcode

    if @do_partial_address_completion_validation
      with_options if: -> address { address.postcode.present? } do |a|
        a.validates :street, presence: { message: 'must be entered' }
      end

      with_options if: -> address { address.street.present? } do |a|
        a.validates :postcode, presence: { message: 'must be entered' }
      end
    end

  end

  def full_postcode
    if postcode.present?
      if !UKPostcode.new(postcode).valid?
        errors.add(:postcode, "Enter a valid postcode for #{subject_description}")
      elsif !UKPostcode.new(postcode).full?
        errors.add(:postcode, "#{subject_description}'s postcode is not a full postcode")
      end
    end
  end

  def address_blank?
    (street.blank? && postcode.blank?)
  end
end
