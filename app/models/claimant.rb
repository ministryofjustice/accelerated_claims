



class Claimant < BaseClass


  include Address
  include ActiveModel::Validations

  attr_accessor :validate_presence, :validate_absence
  attr_accessor :num_claimants
  attr_accessor :claimant_num
  attr_accessor :title
  attr_accessor :full_name


  validates_with ContactValidator
  validates :title, length: { maximum: 8 }
  validates :full_name, length: { maximum: 40 }



  def initialize(params = {})
    super
    unless params.include?(:validate_presence)
      @validate_presence = true unless params[:validate_absence] == true
    end
    @num_claimants = @num_claimants.nil? ? 1 : @num_claimants.to_i
  end
  


  def as_json
    postcode1, postcode2 = split_postcode
    {
      "address" => "#{title} #{full_name}\n#{street}",
      "postcode1" => "#{postcode1}",
      "postcode2" => "#{postcode2}"
    }
  end



  def subject_description
    if @num_claimants == 1
      "the claimant's"
    else
      if @claimant_num == :claimant_one
        "claimant 1's"
      else
        "claimant 2's"
      end
    end
  end

end
