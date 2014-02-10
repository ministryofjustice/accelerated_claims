class ClaimData

  def initialize(params)
    @property = Property.new(params["claim"]["property"])
  end

  def formatted
    data = {}
    data.merge! @property.as_json
    data
  end
end
