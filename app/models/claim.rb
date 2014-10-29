class Claim < BaseClass

  include ActiveSupport::Inflector

  attr_accessor :errors,
                :error_messages,
                :claimants,
                :defendants,
                :form_state,
                :num_claimants,
                :claimant_type,
                :num_defendants

  @@valid_claimant_types    = %w{ organization individual }

  def initialize(claim_params={})
    @javascript_enabled = claim_params.key?('javascript_enabled')

    @claimant_type  = claim_params.key?(:claimant_type) ? claim_params[:claimant_type] : nil
    if @claimant_type == 'organization'
      @num_claimants = 1
      claim_params[:num_claimants] = '1'
    else
      @num_claimants  = claim_params.key?(:num_claimants) ? claim_params[:num_claimants].to_i : nil
    end
    @num_defendants = claim_params.key?(:num_defendants) ? claim_params[:num_defendants].to_i : nil
    initialize_all_submodels(claim_params)
    @errors = ActiveModel::Errors.new(self)
  end

  def javascript_enabled?
    @javascript_enabled
  end

  def method_missing(symbol, *args)
    case symbol
    when /^claimant_(\d)\=$/
      claimants[$1.to_i] = args.first
    when /^claimant_(\d)$/
      claimants[$1.to_i]
    when /^defendant_(\d{1,2})\=$/
      defendants[$1.to_i] = args.first
    when /^defendant_(\d{1,2})$/
      defendants[$1.to_i]
    else
      super(symbol, *args)
    end
  end

  def as_json
    json_in = {}
    attributes_for_submodels.each do |attribute, model|
      submodel_data = instance_variable_get("@#{attribute}").as_json
      json_in[attribute] = submodel_data
    end
    json_in.merge!(@claimants.as_json)
    json_in.merge!(@defendants.as_json)

    cs = ContinuationSheet.new(claimants.further_participants, defendants.further_participants)
    cs.generate
    unless cs.empty?
      json_in.merge!( cs.as_json )
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

    add_fee_and_costs json_out
    tenancy_agreement_status json_out
    defendant_for_service json_out
    json_out
  end

  def valid?
    @errors.clear
    validity = true
    validity = false unless claimant_type_valid?
    validity = false unless num_claimants_valid?
    validity = false unless num_defendants_valid?


    # attributes_for_submodels returns an array of instance_variables and classes, e.g. [ [property, Property], .... ]
    attributes_for_submodels.each do |instance_var, model|
      result = transfer_errors_from_submodel_to_base(instance_var, model, collection: false)
      validity = false if result == false
    end

    attributes_for_submodel_collections.each do |instance_var, model|
      result = transfer_errors_from_submodel_to_base(instance_var, model, collection: true)
      validity = false if result == false
    end
    @error_messages = ErrorMessageSequencer.new.sequence(@errors)
    validity
  end

  private

  # if the perform validation fails - then we need to return false tos that the errors get transfereed

  def transfer_errors_from_submodel_to_base(instance_var, model, options)
    unless send(instance_var).valid?
      if options[:collection] == false || perform_collection_validation_for?(instance_var)
        errors = send(instance_var).errors
          errors.each_with_index do |error, index|
            attribute = error.first
            if options[:collection] == false
              key = "claim_#{instance_var}_#{attribute}_error"
            else
              key = "claim_#{attribute}_error"
            end
          @errors[:base] << [ key, error.last ]
        end
        result = false
      end
    end

    result
  end

  # Calls the method defined for this instance_var to determine whether the claim object is in a state where it is worth
  # validating the instance variable.
  def perform_collection_validation_for?(instance_var)
    method = validation_dependencies_for_submodel_collections[instance_var]
    send(method)
  end

  def claimant_type_valid?
    if @claimant_type_valid_result.nil?
      @claimant_type_valid_result = true
      if @claimant_type.nil?
        @errors[:base] << ['claim_claimant_type_error', 'Please select what kind of claimant you are']
        @claimant_type_valid_result = false
      else
        unless @@valid_claimant_types.include?(@claimant_type)
          @errors[:base] << ['claim_claimant_type_error', 'You must specify a valid kind of claimant']
          @claimant_type_valid_result = false
        end
      end
    end
    @claimant_type_valid_result
  end

  def num_claimants_valid?
    if @num_claimants_valid_result.nil?
      @num_claimants_valid_result = false
      if @claimant_type.present?
        @num_claimants_valid_result = true
        if @num_claimants.nil? || @num_claimants == 0
          @errors[:base] << ['claim_claimant_number_of_claimants_error', 'Please say how many claimants there are']
          @num_claimants_valid_result = false
        elsif @num_claimants > ClaimantCollection.max_claimants
          @errors[:base] << ['claim_claimant_number_of_claimants_error', 'If there are more than 4 claimants in this case, you’ll need to complete your accelerated possession claim on the N5b form']
          @num_claimants_valid_result = false
        end
      end
    end
    @num_claimants_valid_result
  end

  def num_defendants_valid?
    if @num_defendants_valid_result.nil?
      max_num_defendants = DefendantCollection.max_defendants(js_enabled: @javascript_enabled)
      if @num_defendants.blank?
        @errors[:base] << ['claim_defendant_number_of_defendants_error', 'Please say how many defendants there are']
        @num_defendants_valid_result = false
      elsif @num_defendants < 1 || @num_defendants > max_num_defendants
        @errors[:base] << ['claim_defendant_number_of_defendants_error', "Please enter a valid number of defendants between 1 and #{max_num_defendants}"]
        @num_defendants_valid_result = false
      else
        @num_defendants_valid_result = true
      end
    end
    @num_defendants_valid_result
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


  def defendant_for_service hash
    if @num_defendants > 1      
      hash.merge!( {'service_address' => "  \n  \n\tREFER TO CONTINUATION SHEET", 'service_postcode1' => '', 'service_postcode2' => ''} )
    else
      hash.merge!( {'service_address' => hash['defendant_1_address'], 'service_postcode1' => hash['defendant_1_postcode1'], 'service_postcode2' => hash['defendant_1_postcode2'] })
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

  def attributes_for_submodel_collections
    {
      'claimants'  => 'ClaimantCollection',
      'defendants' => 'DefendantCollection'
    }
  end

  def validation_dependencies_for_submodel_collections
    {
      'claimants'   => :validate_claimants?,
      'defendants'  => :validate_defendants?
    }
  end

  def validate_claimants?
    claimant_type_valid? && num_claimants_valid?
  end

  def validate_defendants?
    num_defendants_valid?
  end

  def attributes_for_submodels_and_collections
    attributes_for_submodels.merge attributes_for_submodel_collections
  end

  def attributes_for_submodels
    attributes = {}
    singular_submodels.each { |model| attributes[model.underscore] = model }
    attributes
  end

  def initialize_all_submodels(claim_params)
    attributes_for_submodels.each do |attribute_name, model|
      init_submodel(claim_params, attribute_name, model)
    end
    attributes_for_submodel_collections.each do |attribute, model|
      initialize_submodel_collection(attribute, model, claim_params)
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

  def initialize_submodel_collection(attribute, model, claim_params)
    instance_variable_set("@#{attribute}", model.constantize.new(claim_params))
  end

  def params_for attribute_name, claim_params
    begin
      params = claim_params.key?(attribute_name) ? claim_params[attribute_name] : {}
    rescue NoMethodError => err
      raise NoMethodError.new(err.message + "attribute: #{attribute_name} #{claim_params.inspect}")
    end

    params
  end

end

