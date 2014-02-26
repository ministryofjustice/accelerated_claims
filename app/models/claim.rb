class Claim < BaseClass

  COURT_FEE = "175.00"

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
    add_court_fee json_out
  end

  def valid?
    @errors.clear
    validity = true
    attributes_from_submodels.each do |instance_var, model|
      unless send(instance_var).valid?
        errors = send(instance_var).errors
        messages = errors.full_messages

        errors.each_with_index do |error, index|
          attribute = error.first
          key = "claim_#{instance_var}_#{attribute}_error"
          message = messages[index]
          @errors[:base] << [key, message]
        end
        validity = false
      end
    end
    validity
  end

  private

  def add_court_fee hash
    hash.merge!({ "court_fee" => "#{COURT_FEE}" })
  end

  def singular_submodels
    %w(Property Notice License Deposit Possession Order Tenancy)
  end

  def doubled_submodels
    %w(Claimant Defendant)
  end

  def attributes_from_submodels
    attributes = {}
    singular_submodels.each { |model| attributes[model.underscore] = model }
    doubled_submodels.each do |model|
      %w(one two).each { |n| attributes["#{model.underscore}_#{n}"] = model }
    end
    attributes
  end

  def initialize_all_submodels(claim_params)
    attributes_from_submodels.each do |attribute_name, model|
      init_submodel(claim_params, attribute_name, model)
    end
  end

  def init_submodel(claim_params, attribute_name, model)
    sub_params = params_for(attribute_name, claim_params)

    instance_variable_set("@#{attribute_name}", model.constantize.new(sub_params))

    self.class.send( :define_method, attribute_name.to_sym) {
      instance_variable_get "@#{attribute_name}"
    }
  end

  def params_for attribute_name, claim_params
    params = claim_params.key?(attribute_name) ? claim_params[attribute_name] : {}

    if attribute_name[/claimant_one|defendant_one/]
      params.merge!(validate_presence: true)
    elsif attribute_name[/claimant_two|defendant_two/]
      params.merge!(validate_presence: false)
    end

    params
  end
end
