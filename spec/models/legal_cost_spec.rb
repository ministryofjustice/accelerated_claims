describe LegalCost, :type => :model do

  def legal_cost options={}
    params = claim_post_data['claim']['legal_cost'].merge(options)
    LegalCost.new(params)
  end

  context 'decimal supplied' do
    subject { legal_cost }
    it { is_expected.to be_valid }

    it { expect(legal_cost.as_json).to eq 'legal_costs' => '123.34' }
  end

  context 'non-number supplied' do
    it 'should be invalid' do
      data = legal_cost('legal_costs' => 'xx.x')
      expect(data).not_to be_valid
      expect(data.errors.messages[:legal_costs].first).to eq('must be a valid amount')
    end
  end

  context 'no decimal supplied' do
    it 'should be valid' do
      data = legal_cost('legal_costs' => '123')
      expect(data).to be_valid
      expect(data.legal_costs).to eq('123')
    end
  end

  context 'blank supplied' do
    it 'should be valid' do
      data = legal_cost('legal_costs' => '')
      expect(data).to be_valid
    end
  end
end
