class BaseClass
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON

  def attributes
    instance_values
  end
end
