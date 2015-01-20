
# This class iterates through a claims param hash and normalizes all postcodes
class PostcodeNormalizer

  def initialize(claim_params)
    @claim_params      = claim_params
    @submodel_names    = %w{ property defendant_collection claimant_collection claimant_contact court }

  end

  def normalize
    @submodel_names.each { |submodel| normalize_submodel_postcode(submodel) }
    @claim_params
  end

  private

  def normalize_submodel_postcode(submodel_name)
    if submodel_name =~ /_collection$/
      submodel_names = extract_submodel_names_from_collection_name(submodel_name)
      submodel_names.each { |instance_submodel_name| normalize_submodel_postcode(instance_submodel_name) }
    else
      unless @claim_params[submodel_name]['postcode'].nil?
        postcode = UKPostcode.new(@claim_params[submodel_name]['postcode'])
        if postcode.valid?
          @claim_params[submodel_name]['postcode'] = postcode.norm
        end
      end
    end
  end

  def extract_submodel_names_from_collection_name(collection_name)
    base_name = collection_name.sub(/_collection$/, '')
    matching_keys = @claim_params.keys.select { |k| k =~ /#{base_name}_\d{1,2}$/ }
  end

end
