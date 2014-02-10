class ClaimData

  def initialize(params)
    @property = Property.new(params["claim"]["property"])
    @landlord = Landlord.new(params["claim"]["landlord"])
  end

  def formatted
    data = {}
    data.merge! @property.as_json
    data.merge! @landlord.as_json
    data
  end
end
