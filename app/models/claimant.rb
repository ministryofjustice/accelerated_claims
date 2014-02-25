class Claimant < BaseClass

  attr_accessor :full_name
  validates :full_name, presence: { message: 'must be entered' }

  attr_accessor :street
  validates :street, presence: { message: 'must be entered' }, length: { maximum: 40 }

  attr_accessor :town
  attr_accessor :postcode
  validates :postcode, presence: { message: 'must be entered' }, length: { maximum: 8 }

  def as_json
    postcode1, postcode2 = split_postcode
    {
      "address" => "#{full_name}\n#{street}\n#{town}",
      "postcode1" => "#{postcode1}",
      "postcode2" => "#{postcode2}"
    }
  end
end
