class ReferenceNumber < BaseClass

  attr_accessor :reference_number
  validates :reference_number, length: { maximum: 40 }

  def as_json
    {
      "reference_number" => "#{reference_number}",
    }
  end

end
