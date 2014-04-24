class LegalCost < BaseClass

  attr_accessor :legal_costs

  validates :legal_costs, format: { with: /\A\d+(\.\d{2})?\z/, message: 'must be a valid amount' }, allow_blank: true, length: { maximum: 8 }

  def as_json
    {
      "legal_costs" => "#{legal_costs}"
    }
  end

end
