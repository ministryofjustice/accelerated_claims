describe 'ApplicationHelper', type: :helper  do

  before :each do
    helper.extend Haml
    helper.extend Haml::Helpers
    helper.send :init_haml_helpers
  end

  describe 'section_header' do
    it 'creates h2 header with id and localized text' do
      header = helper.section_header 'claimant'
      expect(header).to eq "<h2 class='section-header' id='claimant-section'>Claimants</h2>\n"
    end
  end
  describe 'external_link' do
    it 'should have set alt text' do
      link = helper.external_link 'http://www.text.com', 'test'
      expect(link).to eq("<a href='http://www.text.com' class='external' rel='external' target='_blank' title='External link, opens in new window'>test</a>")
    end
  end
end
