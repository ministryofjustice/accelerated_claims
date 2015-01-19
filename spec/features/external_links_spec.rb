feature 'External links' do

  before { WebMock.disable_net_connect!(:allow => ["127.0.0.1", /codeclimate.com/]) }

  scenario 'anchor tags with target _blank should have alt text', js: true do
    visit '/'
    page.all("a[target='_blank']").each do |link|
      expect(link[:alt]).to eq('External link, opens in new window')
    end
  end
end
