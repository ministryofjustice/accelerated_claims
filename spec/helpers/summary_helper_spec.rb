describe 'SummaryHelper', type: :helper  do

  before :each do
    helper.extend Haml
    helper.extend Haml::Helpers
    helper.send :init_haml_helpers
  end

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

    context 'for date_served(3i)' do
      it 'creates attribute id without (3i)' do
        key = helper.summary_id 'notice', 'date_served(3i)'
        expect( key ).to eq 'claim_notice_date_served'
      end
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

    context 'for "deposit" "as_money"' do
      it 'returns localized value' do
        value = helper.summary_label 'deposit', 'as_money'
        expect(value).to eq 'Type of deposit'
      end
    end

    context 'for date_served(3i)' do
      it 'returns localized value' do
        value = helper.summary_label 'notice', 'date_served(3i)'
        expect(value).to eq 'Date notice served'
      end
    end
  end

  describe 'summary_value' do
    context 'for value in locale file' do
      it 'returns localized value' do
        value = helper.summary_value 'property', 'house', 'Yes', {}
        expect(value).to eq 'A self-contained house, flat or bedsit'
      end
    end

    context 'for value not in locale file' do
      it 'returns value unaltered' do
        value = helper.summary_value 'defendant_1', 'street', '15 Yellow Brick Rd', {}
        expect(value).to eq '15 Yellow Brick Rd'
      end
    end
  end

  describe 'link_to_edit_section' do
    it 'returns link to section' do
      link = helper.capture_haml do
        helper.link_to_edit_section 'property'
      end
      expect(link).to eq "<a href='#{File.join(root_path,'#property-section')}'>Change property</a>\n"
    end
  end

end
