class Claim < BaseClass
  include ActiveSupport::Inflector

  def initialize(claim_params={})
    submodels.reject {|v| v == 'Tenant'}.each do |model|
      init_submodel(claim_params, model.underscore, model)
    end
    %w(one two).each { |num| init_submodel(claim_params, "tenant_#{num}", 'Tenant') }
  end

  def as_json()
    json = {}
    self.instance_variables.each { |var| json[var.to_s.gsub(/@/, '')] = instance_variable_get(var).as_json }
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
    %w(Property Landlord DemotedTenancy Notice License Deposit Defendant Order Tenant)
  end

end
