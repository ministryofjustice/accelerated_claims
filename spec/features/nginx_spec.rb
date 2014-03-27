# require 'spec_helper'

# feature 'nginx configuration', :remote => true do

#   def path_equal(url1, url2)
#     URI.parse(url1).path == URI.parse(url2).path
#   end

#   scenario 'urls with trailing slashes redirect to the cannonical' do
#     visit '/new/'
#     expect(path_equal(page.current_url, Capybara.app_host + '/new')).to be true
#   end

#   scenario 'http requests redirect to https' do
#     visit '/'
#     expect(page.current_url).to eql Capybara.app_host.gsub('http', 'https')
#   end

#   scenario '/ redirects to /accelerated' do
#     base_url = Capybara.app_host.gsub('http', 'https')
#     visit base_url
#     expect(page.current_url).to eql base_url + "/accelerated"
#   end
# end