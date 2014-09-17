require 'uk_postcode'

module Address

  extend ActiveSupport::Concern

  included do
    attr_accessor :street
    attr_accessor :postcode

    validates :street,   length: { maximum: 70 }
    validates :postcode, length: { maximum: 8 }

    validate :full_postcode
    validate :maximum_number_of_newlines

    if @do_partial_address_completion_validation
      with_options if: -> address { address.postcode.present? } do |a|
        a.validates :street, presence: { message: 'must be entered' }
      end

      with_options if: -> address { address.street.present? } do |a|
        a.validates :postcode, presence: { message: 'must be entered' }
      end
    end

  end


  def maximum_number_of_newlines
    unless street.nil?
      if street.strip.count("\n") > 3
        errors.add(:street, "#{possessive_subject_description.capitalize} address can’t be longer than 4 lines.")
      end
    end
  end



  def full_postcode
    if postcode.present?
      if !UKPostcode.new(postcode).valid?
        errors.add(:postcode, "Enter a valid postcode for #{subject_description}")
      elsif !UKPostcode.new(postcode).full?
        errors.add(:postcode, "#{possessive_subject_description.capitalize} postcode is not a full postcode")
      end
    end
  end

  def address_blank?
    (street.blank? && postcode.blank?)
  end

  def indented_details(spaces_to_indent)
    postcode1, postcode2 = split_postcode
    indentation = ' ' * spaces_to_indent
    str  = "#{indentation}#{title} #{full_name}\n"
    address_lines = street.split("\n")
    address_lines.each { |al| str += "#{indentation}#{al}\n" }
    str += "#{indentation}#{postcode1} #{postcode2}\n"
    str
  end
end
