describe PostcodeLookup::Facade do

  describe '.new' do
    context 'a valid postcode' do
      it 'should return be valid' do
        pclp = PostcodeLookup::Facade.new(['England', 'Wales'],  false)
        result = pclp.lookup 'WC1B5HA'
        expect(result).to be_valid
      end
    end

    context 'invalid postcode' do
      it 'should not be valid' do
        pclp = PostcodeLookup::Facade.new(['England', 'Wales'])
        result = pclp.lookup 'WCX1BGHA'
        expect(result).not_to be_valid
        expect(result).to be_invalid
      end
    end
  end

  context '#lookup using dummy data' do
    it 'should return 422 if postcode invalid' do
      pclp = PostcodeLookup::Facade.new(['All'])
      pclp.lookup 'WCX1BFHA'
        
      expect(pclp.status.message).to eq("Invalid Postcode")
      expect(pclp.status.code).to eq(4220)
      expect(pclp.status.http_status).to eq(422)
    end

    it 'should return 404 if postcode not found' do
      pclp = PostcodeLookup::Facade.new(['All'])
      pclp.lookup 'RG2 0PU'
      expect(pclp.status.message).to eq("Postcode Not Found")
      expect(pclp.status.code).to eq(4040)
      expect(pclp.status.http_status).to eq(404)
    end

    it 'should return 503 if timeout' do
      pclp = PostcodeLookup::Facade.new(['All'])
      pclp.lookup 'RG2 9PU'
      expect(pclp.status.message).to eq "Service Unavailable"
      expect(pclp.status.code).to eq(5030)
      expect(pclp.status.http_status).to eq(503)
    end

    it 'should return valid data set if valid' do
      pclp = PostcodeLookup::Facade.new(['All'])
      pclp.lookup 'BH22 7HR'
      expect(pclp.status.message).to eq "Success"
      expect(pclp.status.result).to eq(expected_status)
      expect(pclp.status.code).to eq(2000)
      expect(pclp.status.http_status).to eq(200)
    end
  end

  context 'country limited to England and Wales' do
    it 'should return success for English Postcode' do
      pclp = PostcodeLookup::Facade.new(['England', 'Wales'])
      pclp.lookup 'BH22 7HR'
      expect(pclp.status.message).to eq "Success"
      expect(pclp.status.result).to eq(expected_status)
    expect(pclp.status.code).to eq(2000)
      expect(pclp.status.http_status).to eq(200)
    end

    it 'should return 200/4041 for Scottish Address' do
      pclp = PostcodeLookup::Facade.new(['England', 'Wales'])
      pclp.lookup 'EH1 5HR'
      expect(pclp.status.message).to eq "Scotland"
      expect(pclp.status.code).to eq(4041)
      expect(pclp.status.http_status).to eq(200)
    end

  end

  context 'calls either development or live_lookup' do
    it 'should call lookup_postcode on a PostcodeLookup::DummyClient if not production' do
      pc = PostcodeLookup::Facade.new([])
      expect_any_instance_of(PostcodeLookup::DummyClient).to receive(:lookup_postcode).and_call_original
      pc.lookup 'WC1B5HA'
    end

    it 'should call lookup_postcode on a PostcodeInfo::Client if use_live_data true' do
      pc = PostcodeLookup::Facade.new([], true)
      expect_any_instance_of(PostcodeInfo::Client).to receive(:lookup_postcode).and_return(api_response)
      pc.lookup 'WC1B5HA'
    end

  end

  context 'logging' do
    it 'should call Logstuff with timeout false if no error' do
      dummy_response = double "Dummy Ideal Postcodes response"
      allow(dummy_response).to receive(:body).and_return(ActiveSupport::JSON.encode("body"))

      expect_any_instance_of(PostcodeInfo::Client).to receive(:lookup_postcode).and_return(dummy_response)
      expect(LogStuff).to receive(:info).with(:postcode_lookup, {timeout: false, endpoint: 'https://postcodeinfo.service.justice.gov.uk/' } )

      pc = PostcodeLookup::Facade.new([], true)
      pc.send(:lookup, 'WC1B5HA')
    end

    it 'should call LogStuff with timeout true if there is a timeout' do
      expect_any_instance_of(PostcodeInfo::Client).to receive(:lookup_postcode).and_raise(Timeout::Error)
      expect(LogStuff).to receive(:info).with(:postcode_lookup, {timeout: true, endpoint: 'https://postcodeinfo.service.justice.gov.uk/' } )

      pc = PostcodeLookup::Facade.new([], true)
      pc.send(:lookup, 'WC1B5HA')
    end
  end

  ##### - A test to check that we can connect to the real remote service - don't use in day-to-day testing

  # describe 'a real lookup to the api' do
  #   it 'should return a result or timeout' do
  #     WebMock.disable_net_connect!(:allow => [/api.ideal-postcodes.co.uk/, /codeclimate.com/] )
  #     pclp = PostcodeLookup::Facade.new('SW109LB', true)
  #     expect(pclp).to be_valid
  #     result = pclp.lookup
  #     if result == true
  #       expect(pclp.empty?).to be false
  #     else
  #       expect(pclp.result_code).to eq 9001
  #     end
  #   end
  # end

end

def api_response
  %Q/{"result":[{"postcode":"ID1 1QD","postcode_inward":"1QD","postcode_outward":"ID1","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"2","building_name":"","sub_building_name":"","po_box":"","department_name":"","organisation_name":"","udprn":25962203,"postcode_type":"S","su_organisation_indicator":"","delivery_point_suffix":"1G","line_1":"2 Barons Court Road","line_2":"","line_3":"","premise":"2","country":"England","county":"","district":"Hammersmith and Fulham","ward":"North End","longitude":-0.208644362766368,"latitude":51.4899488390558,"eastings":524466,"northings":178299},{"postcode":"ID1 1QD","postcode_inward":"1QD","postcode_outward":"ID1","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"2","building_name":"Basement Flat","sub_building_name":"","po_box":"","department_name":"","organisation_name":"","udprn":52618355,"postcode_type":"S","su_organisation_indicator":"","delivery_point_suffix":"3A","line_1":"Basement Flat","line_2":"2 Barons Court Road","line_3":"","premise":"Basement Flat, 2","country":"England","county":"","district":"Hammersmith and Fulham","ward":"North End","longitude":-0.208644362766368,"latitude":51.4899488390558,"eastings":524466,"northings":178299}],"code":2000,"message":"Success"}/
end

def expected_status
  [
      {'address'=>'1 Melbury Close;;FERNDOWN',   'postcode'=>'BH22 8HR', 'country' => 'England' },
      {'address'=>'3 Melbury Close;;FERNDOWN',   'postcode'=>'BH22 8HR', 'country' => 'England' },
      {'address'=>'5 Melbury Close;;FERNDOWN',   'postcode'=>'BH22 8HR', 'country' => 'England' },
      {'address'=>'7 Melbury Close;;FERNDOWN',   'postcode'=>'BH22 8HR', 'country' => 'England' },
      {'address'=>'9 Melbury Close;;FERNDOWN',   'postcode'=>'BH22 8HR', 'country' => 'England' },
      {'address'=>'11 Melbury Close;;FERNDOWN',  'postcode'=>'BH22 8HR', 'country' => 'England' },
      {'address'=>'13 Melbury Close;;FERNDOWN',  'postcode'=>'BH22 8HR', 'country' => 'England' },
      {'address'=>'15 Melbury Close;;FERNDOWN',  'postcode'=>'BH22 8HR', 'country' => 'England' },
      {'address'=>'17 Melbury Close;;FERNDOWN',  'postcode'=>'BH22 8HR', 'country' => 'England' },
      {'address'=>'19 Melbury Close;;FERNDOWN',  'postcode'=>'BH22 8HR', 'country' => 'England' },
      {'address'=>'121 Melbury Close;;FERNDOWN', 'postcode'=>'BH22 8HR', 'country' => 'England' },
      {'address'=>'22 Melbury Close;;FERNDOWN',  'postcode'=>'BH22 8H', 'country' => 'England' },
      {'address'=>'23 Melbury Close;;FERNDOWN',  'postcode'=>'BH22 8HR', 'country' => 'England' }
  ]
end

def dummy_ideal_postcodes_result
  {
    "code" => 2000,
    "message" => "Success",
    "result" =>
    [
      { "address" => "2 Barons Court Road;;LONDON",
        "postcode" => "ID1 1QD",
        "country" => "England"
      },
      { "address" => "Basement Flat;;2 Barons Court Road;;LONDON",
        "postcode" => "ID1 1QD",
        "country" => "England"
      },
      { "address" => "4 Barons Court Road;;LONDON",
        "postcode" => "ID1 1QD",
        "country" => "England"
      },
      { "address" => "Basement;;4 Barons Court Road;;LONDON",
        "postcode" => "ID1 1QD",
        "country" => "England"
      },
      {"address" => "6 Barons Court Road;;LONDON",
        "postcode" => "ID1 1QD",
        "country" => "England"
      },
      { "address" => "8 Barons Court Road;;LONDON",
        "postcode" => "ID1 1QD",
        "country" => "England"
      },
      { "address" => "ID Consulting Limited;;59 Barons Court Road;;LONDON",
        "postcode" => "ID1 1QD",
        "country" => "England"
      }
    ]
  }
end

def scottish_status
  [
      {'address'=>'134, Corstorphine Road;;EDINBURGH', 'postcode'=>'EH12 6TS', 'country' => 'Scotland'},
      {'address'=>'Royal Zoological Society of Scotland;;134, Corstorphine Road;;EDINBURGH', 'postcode'=>'EH12 6TS', 'country' => 'Scotland'}
  ]
end

