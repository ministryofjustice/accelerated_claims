describe LegalCost do

  def legal_cost options={}
    params = claim_post_data['claim']['legal_cost'].merge(options)
    LegalCost.new(params)
  end

  context 'decimal supplied' do
    subject { legal_cost }
    it { should be_valid }

    its(:as_json) { should == { 'legal_costs' => '123.34' } }
  end

  context 'non-number supplied' do
    it 'should be invalid' do
      data = legal_cost('legal_costs' => 'xx.x')
      data.should_not be_valid
      data.errors.messages[:legal_costs].first.should == 'must be a valid amount'
    end
  end

  context 'no decimal supplied' do
    it 'should be valid' do
      data = legal_cost('legal_costs' => '123')
      data.should be_valid
      data.legal_costs.should == '123'
    end
  end

  context 'blank supplied' do
    it 'should be valid' do
      data = legal_cost('legal_costs' => '')
      data.should be_valid
    end
  end
end
