class Defendant < BaseClass

  include Address

  attr_accessor :validate_presence

  attr_accessor :title
  attr_accessor :full_name

  with_options if: :validate_presence do |defendant|
    defendant.validates :title, presence: { message: 'must be entered' }
    defendant.validates :full_name, presence: { message: 'must be entered' }
  end

  validates :title, length: { maximum: 8 }
  validates :full_name, length: { maximum: 40 }

  def as_json
    if defendant_present?
      postcode1, postcode2 = split_postcode
      {
        "address" => "#{title} #{full_name}\n#{street}\n#{town}",
        "postcode1" => postcode1,
        "postcode2" => postcode2
      }
    else
      {}
    end
  end

  private
  def defendant_present?
    !(title.blank? && full_name.blank?)
  end
end
