  class Claim < BaseClass

  include ActiveSupport::Inflector

  attr_accessor :errors
  attr_accessor :error_messages
  attr_accessor :form_state
  attr_accessor :num_claimants
  attr_accessor :claimant_type
  attr_accessor :num_defendants


  @@valid_num_claimants     = [1, 2]
  @@valid_num_defendants    = [1, 2]
  @@ambiguous_instance_vars = ['claimant_one', 'claimant_two', 'defendant_one', 'defendant_two']
  @@valid_claimant_types    = %w{ organization individual }



  def initialize(claim_params={})
    @num_claimants  = claim_params.key?(:num_claimants) ? claim_params[:num_claimants].to_i : nil
    @num_defendants = claim_params.key?(:num_defendants) ? claim_params[:num_defendants].to_i : nil
    @claimant_type  = claim_params.key?(:claimant_type) ? claim_params[:claimant_type] : nil

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
        value = case value
                when TrueClass
                  'Yes'
                when FalseClass
                  'No'
                else
                  value
                end
        attribute = 'claimant_contact' if attribute[/reference_number|legal_cost/]

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
    validity = false unless claimant_type_valid?
    validity = false unless num_claimants_valid? 
    validity = false unless num_defendants_valid?
    attributes_from_submodels.each do |instance_var, model|
      unless send(instance_var).valid?
        errors = send(instance_var).errors
        errors.each_with_index do |error, index|
          attribute = error.first
          key = "claim_#{instance_var}_#{attribute}_error"
          @errors[:base] << [ key, error.last ]
        end
        
        validity = false
      end
    end
    @error_messages = ErrorMessageSequencer.new.sequence(@errors)
    validity
  end

  private

 
  def claimant_type_valid?
    result = true
    if @claimant_type.nil?
      @errors[:base] << ['claim_claimant_type_error', 'You must specify the kind of claimant']
      result = false
    else
      unless @@valid_claimant_types.include?(@claimant_type)
        @errors[:base] << ['claim_claimant_type_error', 'You must specify a valid kind of claimant']
        result = false
      end
    end
    result
  end


  def num_claimants_valid?
    if @claimant_type.present?
      unless @@valid_num_claimants.include?(@num_claimants)
        @errors[:base] << ['claim_num_claimants_error', 'Please say how many claimants there are']
        return false
      end
    end
    true
  end

  def num_defendants_valid?
    unless @@valid_num_defendants.include?(@num_defendants)
      @errors[:base] << ['claim_num_defendants_error', 'Please say how many defendants there are']
      return false
    end
    true
  end


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
    if @tenancy.demoted_tenancy?
      blank_out_replacement_tenancy_agreement_status hash
    else
      set_replacement_tenancy_agreement_status hash if @tenancy.only_start_date_present?
    end
  end

  def blank_out_replacement_tenancy_agreement_status hash
    hash["tenancy_agreement_reissued_for_same_landlord_and_tenant"] = ""
    hash["tenancy_agreement_reissued_for_same_property"] = ""
    hash
  end

  def latest_tenancy_agreement?
    !@tenancy.latest_agreement_date.blank?
  end

  def set_replacement_tenancy_agreement_status hash
    hash["tenancy_agreement_reissued_for_same_landlord_and_tenant"] = "NA"
    hash["tenancy_agreement_reissued_for_same_property"] = "NA"
    hash
  end

  def singular_submodels
    %w(Fee Property Notice License Deposit Possession Order Tenancy ClaimantContact LegalCost ReferenceNumber)
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
    begin
      params = claim_params.key?(attribute_name) ? claim_params[attribute_name] : {}
    rescue NoMethodError => err
      raise NoMethodError.new(err.message + "attribute: #{attribute_name} #{claim_params.inspect}")
    end
    


    case attribute_name
      when /claimant_one/
        if @num_claimants.nil?
          params.merge!(validate_presence: false, validate_absence: false, num_claimants: nil, claimant_num: :claimant_one, claimant_type: claimant_type)  
        else
          params.merge!(validate_presence: true, validate_absence: false, num_claimants: claim_params[:num_claimants], claimant_num: :claimant_one, claimant_type: claimant_type)
        end
      when /claimant_two/
        if @num_claimants.nil?
          params.merge!(validate_absence: false, validate_presence: false, num_claimants: nil, claimant_num: :claimant_two)
        elsif @num_claimants == 1
          params.merge!(validate_absence: true, validate_presence: false)
        else
          params.merge!(validate_presence: true, num_claimants: '2', claimant_num: :claimant_two, claimant_type: claimant_type)
        end
      when /defendant_one/
        if @num_defendants.nil?
          params.merge!(validate_presence: false, validate_absence: false, num_defendants: nil, defendant_num: :defendant_one)  
        else
          params.merge!(validate_presence: true, validate_absence: false, num_defendants: claim_params[:num_defendants], defendant_num: :defendant_one)
        end
      when /defendant_two/
        if @num_defendants.nil?
          params.merge!(validate_absence: false, validate_presence: false)
        elsif @num_defendants == 1
          params.merge!(validate_absence: true, validate_presence: false)
        else
          params.merge!(validate_presence: true, num_defendants: '2', defendant_num: :claimant_two)
        end
    end

    params
  end

end
