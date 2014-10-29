describe 'ApplicationHelper', type: :helper  do

  before :each do
    helper.extend Haml
    helper.extend Haml::Helpers
    helper.send :init_haml_helpers
  end

  describe 'section_header' do
    it 'creates h2 header with id and localized text' do
      header = helper.section_header 'claimant'
      expect(header).to eq "<h2 class='section-header' id='claimant-section'>\n  Claimants\n</h2>\n"
    end
  end

end
