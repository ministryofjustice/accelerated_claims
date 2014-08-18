class Claim < BaseClass

  include ActiveSupport::Inflector

  attr_accessor :errors,
                :error_messages,
                :claimants,
                :form_state,
                :num_claimants,
                :claimant_type,
                :num_defendants


  @@max_num_claimants       = 4
  @@valid_num_defendants    = [1, 2]

  @@valid_claimant_types    = %w{ organization individual }



  def initialize(claim_params={})
    @claimant_type  = claim_params.key?(:claimant_type) ? claim_params[:claimant_type] : nil
    if @claimant_type == 'organization'
      @num_claimants = 1
    else
      @num_claimants  = claim_params.key?(:num_claimants) ? claim_params[:num_claimants].to_i : 0
    end
    @num_defendants = claim_params.key?(:num_defendants) ? claim_params[:num_defendants].to_i : nil
    initialize_all_submodels(claim_params)
    @errors = ActiveModel::Errors.new(self)
  end


  def method_missing(meth, *args)
    meth_string = meth.to_s
    if meth_string =~ /^claimant_(\d)\=$/
      claimants[$1.to_i] = args.first
    elsif meth_string =~ /^claimant_(\d)$/
      claimants[$1.to_i]
    else
      super(meth, *args)
    end
  end



  def as_json
    json_in = {}
    attributes_for_submodels.each do |attribute, model|
      submodel_data = instance_variable_get("@#{attribute}").as_json
      json_in[attribute] = submodel_data
    end
    json_in.merge!(@claimants.as_json)

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

  def transfer_errors_from_submodel_to_base(instance_var, model, options)
    result = true
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


############# TODO  TIDY THIS UP _ MEMOIZING RESULT OF NUM CLKAIMANTS

  def num_claimants_valid?
    if @num_claimants_valid_result.nil?
      @num_claimants_valid_result = false
      if @claimant_type.present?
        @num_claimants_valid_result = true
        if @num_claimants.nil? || @num_claimants == 0
          @errors[:base] << ['claim_num_claimants_error', 'Please say how many claimants there are']
          @num_claimants_valid_result = false
        elsif @num_claimants > @@max_num_claimants
          @errors[:base] << ['claim_num_claimants_error', 'If there are more than 4 claimants in this case, you’ll need to complete your accelerated possession claim on the N5b form (LINK: http://hmctsformfinder.justice.gov.uk/HMCTS/GetForm.do?court_forms_id=618)']
          @num_claimants_valid_result = false
        end
      end
    end
    @num_claimants_valid_result
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
    %w(Defendant)
  end

  def attributes_for_submodel_collections
    { 'claimants' => 'ClaimantCollection' }
  end


  def validation_dependencies_for_submodel_collections
    { 'claimants' => :validate_claimants? }
  end


  def validate_claimants?
    claimant_type_valid? && num_claimants_valid?
  end


  def attributes_for_submodels_and_collections
    attributes_for_submodels.merge attributes_for_submodel_collections
  end


  def attributes_for_submodels
    attributes = {}
    singular_submodels.each { |model| attributes[model.underscore] = model }
  
    doubled_submodels.each do |model|
      %w(one two).each { |n| attributes["#{model.underscore}_#{n}"] = model }
    end
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
    


    case attribute_name
      when /claimant_1/
        if @num_claimants.nil?
          params.merge!(validate_presence: false, validate_absence: false, num_claimants: nil, claimant_num: :claimant_1, claimant_type: claimant_type)  
        else
          params.merge!(validate_presence: true, validate_absence: false, num_claimants: claim_params[:num_claimants], claimant_num: :claimant_1, claimant_type: claimant_type)
        end
      when /claimant_2/
        if @num_claimants.nil?
          params.merge!(validate_absence: false, validate_presence: false, num_claimants: nil, claimant_num: :claimant_2)
        elsif @num_claimants == 1
          params.merge!(validate_absence: true, validate_presence: false)
        else
          params.merge!(validate_presence: true, num_claimants: '2', claimant_num: :claimant_2, claimant_type: claimant_type)
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
          params.merge!(validate_presence: true, num_defendants: '2', defendant_num: :defendant_two)
        end
    end

    params
  end

end
