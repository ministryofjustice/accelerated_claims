class DepositChecklist
  def initialize(json)
    @json = json
  end

  def add
    add_deposit_text
    @json
  end

  def add_deposit_text
    if @json['deposit_received'] == 'Yes' && @json['deposit_as_money'] == 'Yes'
      deposit_text = "- The tenancy deposit scheme certificate or insurance premium certificate - marked 'F'\n\n"
      @json['required_documents'] = @json['required_documents'].concat deposit_text
    end
  end
end
