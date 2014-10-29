describe 'SummaryHelper', type: :helper  do

  describe 'localization_key' do
    it 'creates key for locale file lookup' do
      key = helper.localization_key 'defendant_1', 'street', 'label'
      expect( key ).to eq 'claim.defendant.street.label'
    end
  end

  describe 'summary_id' do
    it 'creates attribute id' do
      key = helper.summary_id 'defendant_1', 'street'
      expect( key ).to eq 'claim_defendant_1_street'
    end
  end

  describe 'summary_label' do
    context 'for value in locale file' do
      it 'returns localized value' do
        value = helper.summary_label 'defendant_1', 'street'
        expect(value).to eq 'Full address'
      end
    end

    context 'for value not in locale file' do
      it 'returns humanized value' do
        value = helper.summary_label 'defendant_1', 'example_label'
        expect(value).to eq 'Example label'
      end
    end
  end

  describe 'summary_value' do
    context 'for value in locale file' do
      it 'returns localized value' do
        value = helper.summary_value 'property', 'house', 'Yes'
        expect(value).to eq 'A self-contained house, flat or bedsit'
      end
    end

    context 'for value not in locale file' do
      it 'returns value unaltered' do
        value = helper.summary_value 'defendant_1', 'street', '15 Yellow Brick Rd'
        expect(value).to eq '15 Yellow Brick Rd'
      end
    end
  end

end
