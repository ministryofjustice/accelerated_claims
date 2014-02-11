class Claim < BaseClass
  include ActiveSupport::Inflector

  def initialize(claim_params={})
    initialize_all_submodels(claim_params)
  end

  def as_json()
    json = {}
    attributes_from_submodels.each { |var, model| json.merge! instance_variable_get("@#{var}").as_json }
    json
  end

  private

  def submodels
    %w(Property Landlord DemotedTenancy Notice License Deposit Defendant Order Tenant)
  end

  def attributes_from_submodels
    attributes = {} 
    submodels.reject { |m| m == 'Tenant' }.each { |model| attributes[model.underscore] = model }
    %w(one two).each { |n| attributes["tenant_#{n}"] = 'Tenant' }
    attributes
  end

  def initialize_all_submodels(params)
    attributes_from_submodels.each { |attribute, model|
      init_submodel(params, attribute, model)
    }
  end

  def init_submodel(claim_params, instance_var, model)
    sub_params = claim_params.has_key?(instance_var) ? claim_params[instance_var] : {}
    instance_variable_set("@#{instance_var}", model.constantize.new(sub_params))
    self.class.send( :define_method, instance_var.to_sym) {
      instance_variable_get "@#{instance_var}"
    }
  end
end
