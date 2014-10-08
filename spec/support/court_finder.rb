def court_finder_stub(postcode, body: '', code: 200)
  url = "#{Courtfinder::SERVER}#{Courtfinder::Client::HousingPossession::PATH}#{postcode}"
  stub_request(:get, url)
    .to_return(:status => 200, :body => body, :headers => {})
end
