class Claimant < BaseClass

  attr_writer :do_validation

  attr_accessor :title
  attr_accessor :full_name

  attr_accessor :street
  attr_accessor :town
  attr_accessor :postcode

  with_options if: :do_validation do |claimant|
    claimant.validates :title, presence: { message: 'must be entered' }, length: { maximum: 8 }
    claimant.validates :full_name, presence: { message: 'must be entered' }
    claimant.validates :street, presence: { message: 'must be entered' }, length: { maximum: 40 }
    claimant.validates :postcode, presence: { message: 'must be entered' }, length: { maximum: 8 }
  end

  def do_validation
    @do_validation
  end

  def as_json
    postcode1, postcode2 = split_postcode
    {
      "address" => "#{title} #{full_name}\n#{street}\n#{town}",
      "postcode1" => "#{postcode1}",
      "postcode2" => "#{postcode2}"
    }
  end
end
