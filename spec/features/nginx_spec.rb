feature 'nginx configuration', :remote => true do

  def path_equal(url1, url2)
    URI.parse(url1).path == URI.parse(url2).path
  end

  scenario 'http requests redirect to https' do
    visit '/'
    expect(page.current_url).to match /^https:\/\/.*\/accelerated-possession-eviction/
  end

  if ENV['env'] == 'production' || ENV['env'] == 'staging'
    scenario '/ redirects to /accelerated-possession-eviction' do
      service_url = Capybara.app_host.sub('http:', 'https:')
      base_url = service_url.sub('/accelerated-possession-eviction','/')
      visit base_url
      expected_url = (ENV['env'] == 'production') ? 'https://www.gov.uk/accelerated-possession-eviction' : service_url.sub(/\/\/[^@]+@/, '//')
      expect(page.current_url).to eql expected_url
    end
  end
end
