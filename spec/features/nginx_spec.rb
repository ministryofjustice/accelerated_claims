feature 'nginx configuration', :remote => true do

  def path_equal(url1, url2)
    URI.parse(url1).path == URI.parse(url2).path
  end

  scenario 'http requests redirect to https' do
    visit '/'
    expect(page.current_url).to eql Capybara.app_host.sub('http:', 'https:')
  end

  scenario '/ redirects to /accelerated-possession-eviction' do
    base_url = Capybara.app_host.sub('http:', 'https:').sub('/accelerated-possession-eviction','/')
    visit base_url
    expect(page.current_url).to eql base_url + 'accelerated-possession-eviction'
  end
end
