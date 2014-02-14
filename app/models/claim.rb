class Claim < BaseClass
  include ActiveSupport::Inflector

  attr_accessor :errors

  def initialize(claim_params={})
    initialize_all_submodels(claim_params)
    @errors = ActiveModel::Errors.new(self)
  end

  def as_json
    json_in = {}
    attributes_from_submodels.each { |var, model| json_in[var] = instance_variable_get("@#{var}").as_json }
    json_out = {}
    json_in.each do |attribute, submodel|
      submodel.each do |key, value|
        value = 'Yes' if(value.class.name == 'TrueClass')
        value = 'No' if(value.class.name == 'FalseClass')
        json_out["#{attribute}_#{key}"] = value
      end
    end
    json_out
  end

  def valid?
    @errors.clear
    validity = true
    attributes_from_submodels.each do |instance_var, model|
      unless self.send(instance_var).valid?
        self.send(instance_var).errors.full_messages.each { |m| @errors[:base] << m }
        validity = false
      end
    end
    validity
  end

  private

  def singular_submodels
    %w(Property Landlord Notice License Deposit Possession Order Tenancy)
  end

  def doubled_submodels
    %w(Tenant)
  end

  def attributes_from_submodels
    attributes = {}
    singular_submodels.each { |model| attributes[model.underscore] = model }
    doubled_submodels.each do |model|
      %w(one two).each { |n| attributes["#{model.underscore}_#{n}"] = model }
    end
    attributes
  end

  def initialize_all_submodels(params)
    attributes_from_submodels.each { |attribute, model|
      init_submodel(params, attribute, model)
    }
  end

  def init_submodel(claim_params, instance_var, model)
    sub_params = claim_params.key?(instance_var) ? claim_params[instance_var] : {}
    instance_variable_set("@#{instance_var}", model.constantize.new(sub_params))
    self.class.send( :define_method, instance_var.to_sym) {
      instance_variable_get "@#{instance_var}"
    }
  end
end
