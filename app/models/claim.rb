class Claim < BaseClass

  include ActiveSupport::Inflector

  attr_accessor :errors

  attr_accessor :form_state

  def initialize(claim_params={})
    initialize_all_submodels(claim_params)
    @errors = ActiveModel::Errors.new(self)
  end

  def as_json
    json_in = {}
    attributes_from_submodels.each do |attribute, model|
      submodel_data = instance_variable_get("@#{attribute}").as_json
      json_in[attribute] = submodel_data
    end

    json_out = {}
    json_in.each do |attribute, submodel_data|
      submodel_data.each do |key, value|
        value = 'Yes' if(value.class.name == 'TrueClass')
        value = 'No' if(value.class.name == 'FalseClass')
        json_out["#{attribute}_#{key}"] = value
      end
    end

    populate_defendants_address_if_blank json_out
    add_fee_and_costs json_out
    tenancy_agreement_status json_out
    json_out
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

  def populate_defendants_address_if_blank hash
    if defendant_one.present? && defendant_one.address_blank?
      hash['defendant_one_address'] << hash['property_address']
      hash['defendant_one_postcode1'] = hash['property_postcode1']
      hash['defendant_one_postcode2'] = hash['property_postcode2']
    end
    if defendant_two.present? && defendant_two.address_blank?
      hash['defendant_two_address'] << hash['property_address']
      hash['defendant_two_postcode1'] = hash['property_postcode1']
      hash['defendant_two_postcode2'] = hash['property_postcode2']
    end
  end

  def add_fee_and_costs hash
    if hash["claimant_contact_legal_costs"].blank?
      hash.merge!({ "total_cost" => "#{hash["fee_court_fee"]}" })
    else
      cost = ((hash["fee_court_fee"].to_f * 100) + (hash["claimant_contact_legal_costs"].to_f * 100)) / 100
      hash.merge!({ "total_cost" => "#{cost}" })
    end
  end

  def tenancy_agreement_status hash
    if hash["demoted_tenancy_demoted_tenancy"] == 'No'
      set_replacement_tenancy_agreement_status hash if latest_tenancy_agreement? hash
    end
  end

  def latest_tenancy_agreement? hash
    [hash["tenancy_latest_agreement_date_day"],
     hash["tenancy_latest_agreement_date_month"],
     hash["tenancy_latest_agreement_date_year"]].all?
  end

  def set_replacement_tenancy_agreement_status hash
    hash["tenancy_agreement_reissued_for_same_landlord_and_tenant"] = "NA"
    hash["tenancy_agreement_reissued_for_same_property"] = "NA"
    hash
  end

  def singular_submodels
    %w(Fee Property Notice License Deposit Possession Order DemotedTenancy Tenancy ClaimantContact)
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
    tenancy.demoted_tenancy = demoted_tenancy.demoted_tenancy?
    self.form_state = claim_params['form_state'] if claim_params['form_state'].present?
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
