class Claimant < BaseClass

  include Address

  attr_accessor :validate_presence

  attr_accessor :title
  attr_accessor :full_name

  with_options if: :validate_presence do |claimant|
    # claimant.validates :title,     presence: { message: 'must be entered' } # Organisations don't have titles
    claimant.validates :full_name, presence: { message: 'must be entered' }
    claimant.validates :street,    presence: { message: 'must be entered' }
    claimant.validates :postcode,  presence: { message: 'must be entered' }
  end

  validates :title, length: { maximum: 8 }
  validates :full_name, length: { maximum: 40 }

  def as_json
    postcode1, postcode2 = split_postcode
    {
      "address" => "#{title} #{full_name}\n#{street}\n#{town}",
      "postcode1" => "#{postcode1}",
      "postcode2" => "#{postcode2}"
    }
  end
end
