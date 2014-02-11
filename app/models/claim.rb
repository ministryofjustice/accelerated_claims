class Claim < BaseClass
  include ActiveSupport::Inflector

  def initialize(claim_params={})
    initialize_all_submodels(claim_params)
  end

  def as_json()
    json = {}
    self.instance_variables.each { |var| json.merge! instance_variable_get(var).as_json }
    json
  end

  private

  def init_submodel(claim_params, instance_var, model)
    sub_params = claim_params.has_key?(instance_var) ? claim_params[instance_var] : {}
    instance_variable_set("@#{instance_var}", model.constantize.new(sub_params))
    self.class.send( :define_method, instance_var.to_sym) {
      instance_variable_get "@#{instance_var}"
    }
  end

  def submodels
    %w(Property Landlord DemotedTenancy Notice License Deposit Defendant Order)
  end

  def tenant_submodels
    %w(one two)
  end

  def initialize_all_submodels(params)
    submodels.each { |model|
      init_submodel(params, model.underscore, model)
    }
    tenant_submodels.each { |num|
      init_submodel(params, "tenant_#{num}", 'Tenant')
    }
  end
end
