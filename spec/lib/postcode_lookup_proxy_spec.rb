describe PostcodeLookupProxy do

  describe '.new' do
    context 'a valid postcode' do
      it 'should return be valid' do
        pclp = PostcodeLookupProxy.new('WC1B5HA', ['England', 'Wales'],  false)
        expect(pclp).to be_valid
      end
    end

    context 'invalid postcode' do
      it 'should not be valid' do
        pc = PostcodeLookupProxy.new('WCX1B5HA', ['England', 'Wales'])
        expect(pc).not_to be_valid
        expect(pc).to be_invalid
      end
    end
  end


  context '#lookup using dummy data' do
    it 'should return 422 if postcode invalid' do
      pclp = PostcodeLookupProxy.new('WCX1B5HA', [])
      pclp.lookup
      expect(pclp.result_set).to eq ( {"code"=>4220, "message"=>"Invalid Postcode"} )
      expect(pclp.http_status).to eq 422
    end

    it 'should return 404 if postcode not found' do
      pclp = PostcodeLookupProxy.new('RG2 0PU', [])
      pclp.lookup
      expect(pclp.result_set).to eq ( {"code"=>4040, "message"=>"Postcode Not Found"} )
      expect(pclp.http_status).to eq 404
    end

    it 'should return 503 if timeout' do
      pclp = PostcodeLookupProxy.new('RG2 9PU', [])
      pclp.lookup
      expect(pclp.result_set).to eq ( {"code"=>5030, "message"=>"Service Unavailable"} )
      expect(pclp.http_status).to eq 503
    end

    it 'should return valid data set if valid' do
      pclp = PostcodeLookupProxy.new('BH22 7HR', [])
      pclp.lookup
      expect(pclp.result_set).to eq ( {"code"=>2000, "message"=>"Success", 'result' => expected_result_set } )
      expect(pclp.http_status).to eq 200
    end
  end


  # The following tests are not intended to be run on a daily basis, but if required can be run by setting the 
  # environment variable 'LIVEPC=idealpostcodes'
  #
  if ENV['LIVEPC'] == 'idealpostcodes'
    context 'lookup using live data' do
      it 'should return 422 if postcode invalid' do
        pclp = PostcodeLookupProxy.new('WCX1B5HA', [], true)
        pclp.lookup
        expect(pclp.result_set).to eq ( {"code"=>4220, "message"=>"Invalid Postcode"} )
        expect(pclp.http_status).to eq 422
      end

      it 'should return 404 if postcode not found' do
        WebMock.disable_net_connect!(:allow => [/api.ideal-postcodes.co.uk/, /codeclimate.com/] )
        pclp = PostcodeLookupProxy.new('RG2 0PU', [], true)
        pclp.lookup
        expect(pclp.result_set).to eq ( {"code"=>4040, "message"=>"Postcode Not Found"} )
        expect(pclp.http_status).to eq 404
      end

      it 'should return 503 if timeout' do
        WebMock.disable_net_connect!(:allow => [/api.ideal-postcodes.co.uk/, /codeclimate.com/] )
        pclp = PostcodeLookupProxy.new('RG2 9PU', [], true)
        expct(Excon).to receive(:get).and_raise_error(Timeout::Error)
        pclp.lookup
        expect(pclp.result_set).to eq ( {"code"=>5030, "message"=>"Service Unavailable"} )
        expect(pclp.http_status).to eq 503
      end

      it 'should return valid data set if valid' do
        WebMock.disable_net_connect!(:allow => [/api.ideal-postcodes.co.uk/, /codeclimate.com/] )
        pclp = PostcodeLookupProxy.new('ID1 1QD', [], true)
        pclp.lookup
        expect(pclp.result_set).to eq ( dummy_ideal_postcodes_result )
        expect(pclp.http_status).to eq 200
      end
    end
  end


  context 'calls either development or production lookup' do
    it 'should call development lookup if not production' do
      pc = PostcodeLookupProxy.new('WC1B5HA', [])
      expect(pc).to receive(:development_lookup).and_call_original
      pc.lookup
    end

    it 'should call production lookup if use_live_data true' do
      pc = PostcodeLookupProxy.new('WC1B5HA', [], true)
      expect(pc).to receive(:production_lookup).and_return(api_response)
      pc.lookup
    end

  end

end




def api_response
  %Q/{"result":[{"postcode":"ID1 1QD","postcode_inward":"1QD","postcode_outward":"ID1","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"2","building_name":"","sub_building_name":"","po_box":"","department_name":"","organisation_name":"","udprn":25962203,"postcode_type":"S","su_organisation_indicator":"","delivery_point_suffix":"1G","line_1":"2 Barons Court Road","line_2":"","line_3":"","premise":"2","country":"England","county":"","district":"Hammersmith and Fulham","ward":"North End","longitude":-0.208644362766368,"latitude":51.4899488390558,"eastings":524466,"northings":178299},{"postcode":"ID1 1QD","postcode_inward":"1QD","postcode_outward":"ID1","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"2","building_name":"Basement Flat","sub_building_name":"","po_box":"","department_name":"","organisation_name":"","udprn":52618355,"postcode_type":"S","su_organisation_indicator":"","delivery_point_suffix":"3A","line_1":"Basement Flat","line_2":"2 Barons Court Road","line_3":"","premise":"Basement Flat, 2","country":"England","county":"","district":"Hammersmith and Fulham","ward":"North End","longitude":-0.208644362766368,"latitude":51.4899488390558,"eastings":524466,"northings":178299}],"code":2000,"message":"Success"}/
end




def expected_result_set
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


# def scottish_result_set
#   [
#       {'address'=>'134, Corstorphine Road;;EDINBURGH', 'postcode'=>'EH12 6TS', 'country' => 'Scotland'}, 
#       {'address'=>'Royal Zoological Society of Scotland;;134, Corstorphine Road;;EDINBURGH', 'postcode'=>'EH12 6TS', 'country' => 'Scotland'} 
#   ]
# end

