class Defendant < BaseClass

  @do_partial_address_completion_validation = true
  include Address

  attr_accessor :first_defendant

  attr_accessor :title
  attr_accessor :full_name

  validates :title, length: { maximum: 8 }
  validates :full_name, length: { maximum: 40 }

  with_options if: :first_defendant do |defendant|
    defendant.validates :title, presence: { message: 'must be entered' }
    defendant.validates :full_name, presence: { message: 'must be entered' }
  end

  with_options if: -> d { !d.first_defendant && d.title.present? } do |defendant|
    defendant.validates :full_name, presence: { message: 'must be entered' }
  end

  with_options if: -> d { !d.first_defendant && d.full_name.present? } do |defendant|
    defendant.validates :title, presence: { message: 'must be entered' }
  end

  with_options if: -> d { !d.first_defendant && (d.street.present? || d.postcode.present?) && (d.title.blank? && d.full_name.blank?) } do |defendant|
    defendant.validates :title, presence: { message: 'must be entered' }
    defendant.validates :full_name, presence: { message: 'must be entered' }
  end

  def as_json
    if present?
      postcode1, postcode2 = split_postcode
      {
        "address" => "#{title} #{full_name}\n#{street}",
        "postcode1" => postcode1,
        "postcode2" => postcode2
      }
    else
      {}
    end
  end

  def present?
    !(title.blank? && full_name.blank?)
  end
end
