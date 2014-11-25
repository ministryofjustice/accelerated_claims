require 'uk_postcode'

module Address

  extend ActiveSupport::Concern

  included do
    attr_accessor :street
    attr_accessor :postcode

    validates :street,   length: { maximum: 70 }
    validate :maximum_number_of_newlines

    if @do_partial_address_completion_validation
      with_options if: -> address { address.postcode.present? } do |a|
        a.validates :street, presence: { message: 'Enter the full address' }
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
