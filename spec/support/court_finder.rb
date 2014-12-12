def court_finder_stub(postcode, body: '', code: 200)
  url = "#{Courtfinder::SERVER}#{Courtfinder::Client::HousingPossession::PATH}#{postcode}"
  stub_request(:get, url)
    .to_return(:status => code, :body => body, :headers => {})
end

def court_address
  [{
     'name' => 'Cambridge County Court and Family Court',
     'address' => {
       'town' => 'Cambridge',
       'address_lines' => ['Cambridge County Court and Family
                            Court Hearing Centre'.sub('  ', ''),
                           '197 East Road'],
       'type' => 'Postal',
       'postcode' => 'CB1 1BA',
       'county' => 'Cambridgeshire'
     }
   }]
end
