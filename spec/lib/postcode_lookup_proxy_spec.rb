describe PostcodeLookupProxy do

  describe '.new' do
    context 'a valid postcode' do
      it 'should return be valid' do
        pclp = PostcodeLookupProxy.new('WC1B5HA', false)
        expect(pclp).to be_valid
      end
    end

    context 'invalid postcode' do
      it 'should not be valid' do
        pc = PostcodeLookupProxy.new('WCX1B5HA')
        expect(pc).not_to be_valid
        expect(pc).to be_invalid
      end
    end
  end


  describe '#lookup' do
    it 'should raise if postcode invalid' do
      pclp = PostcodeLookupProxy.new('WCX1B5HA')
      expect{
        pclp.lookup
      }.to raise_error RuntimeError, "Invalid Postcode"
    end

    it 'should call development lookup if not production' do
      pc = PostcodeLookupProxy.new('WC1B5HA')
      expect(pc).to receive(:development_lookup)
      pc.lookup
    end

    it 'should call production lookup if use_live_data true' do
      pc = PostcodeLookupProxy.new('WC1B5HA', true)
      expect(pc).to receive(:production_lookup)
      pc.lookup
    end
  end



  describe '#empty?' do
    it 'should raise error if called before lookup' do
      pclp = PostcodeLookupProxy.new('RG2 7PU')
      expect {
        pclp.empty?
      }.to raise_error RuntimeError, "Call PostcodeProxyLookup#lookup before PostcodeProxyLookup.empty?"
    end

    it 'should return true if result_set empty' do
      pclp = PostcodeLookupProxy.new('RG2 0PP')
      expect(pclp.lookup).to be true
      expect(pclp.empty?).to be true
    end

    it 'should return false if result set not empty' do
      pclp = PostcodeLookupProxy.new('RG2 8PP')
      expect(pclp.lookup).to be true
      expect(pclp.empty?).to be false
    end
  end


  describe 'private method production_lookup' do
    context 'timely lookup' do
      it 'should call ideal-postcodes and return true, transforming the api into @result_set' do
        pclp = PostcodeLookupProxy.new('SW10 9LN')

        response = double('Http Repsonse')
        expect(Excon).to receive(:get).and_return(response)
        expect(response).to receive(:status).and_return(200).at_least(1)
        expect(response).to receive(:body).and_return(api_response)

        expect(pclp.send(:production_lookup)).to be true
        expect(pclp.result_set).to eq [
          {"address"=>"2 Barons Court Road;;LONDON", "postcode"=>"ID1 1QD"}, 
          {"address"=>"Basement Flat;;2 Barons Court Road;;LONDON", "postcode"=>"ID1 1QD"}
        ]
      end
    end

    context 'call to ideal postcodes times out' do
      it 'should return false' do
        pclp = PostcodeLookupProxy.new('SW10 9LN')
        expect(Excon).to receive(:get).and_raise Timeout::Error
        expect(pclp.send(:production_lookup)).to be false
      end
    end
  end


  describe 'private method transform_api_address' do
    context 'lines 2 and 3 blank' do
      it 'should return simple first line and postcode' do
        pclp = PostcodeLookupProxy.new('id1 1qd')
        transformed = pclp.send(:transform_api_address, single_line_address)
        expect(transformed).to eq({'address' => '2 Barons Court Road;;LONDON', 'postcode' => 'ID1 1QD' })
      end
    end

    context '3 line address' do
      it 'should return a 3-line address' do
        pclp = PostcodeLookupProxy.new('id1 1qd')
        transformed = pclp.send(:transform_api_address, three_line_address)
        expect(transformed).to eq({'address' => 'Basement Flat;;Dunroamin;;5 Barons Court Road;;LONDON', 'postcode' => 'ID1 1QD' })
      end
    end
  end


  describe 'private method transform_api_response' do
    it 'should return an array of addresses' do
      pclp = PostcodeLookupProxy.new('id1 1qd')
      http_response = double "HttpResponse"
      expect(http_response).to receive(:body).and_return(api_response)
      transformed = pclp.send(:transform_api_response, http_response)
      expect(transformed).to eq [ {"address"=>"2 Barons Court Road;;LONDON", "postcode"=>"ID1 1QD"},
                                  {"address"=>"Basement Flat;;2 Barons Court Road;;LONDON","postcode"=>"ID1 1QD"}]
    end
  end



  describe 'private method form_url' do
    it 'should return a validly formed url' do
      pclp = PostcodeLookupProxy.new('dw10 9xh')
      expect(pclp.send(:form_url)).to eq "https://api.ideal-postcodes.co.uk/v1/postcodes/DW109XH?api_key=ak_i09ecaamj9h7zaGvj3Vu1pjpzgdvE"
    end
  end




  describe 'private method development_lookup' do
    it 'should return true and populate result set with an empty array if the first digit of the 2nd part of the postcode is zero' do
      pc = PostcodeLookupProxy.new('SW150HG')
      expect(pc.send(:development_lookup)).to be true
      expect(pc.result_set).to eq []
    end

    it 'should return false if first digit of 2nd part of postcode is 9' do
      pc = PostcodeLookupProxy.new('SW159HG')
      expect(pc.send(:development_lookup)).to be false
    end


    it 'should return the 2nd element of the dummy postcode results with a first digit of 2nd part of postcode is 1' do
      pc = PostcodeLookupProxy.new('BR31ES')
      expect(pc.send(:development_lookup)).to be true
      expect(pc.result_set).to eq expected_result_set
    end
  end

  context 'error reporting' do
    it 'should return false if remote service returns http status 200' do
      http_response = double('HTTPResponse')
      expect(Excon).to receive(:get).and_return(http_response)
      expect(http_response).to receive(:status).and_return(200).at_least(1)
      expect(http_response).to receive(:body).and_return(api_response)

      pclp = PostcodeLookupProxy.new('BR31ES', true)
      expect(pclp.lookup).to be true
      expect(pclp.errors?).to be false
    end

    it 'should return true if remote service returns anything other than 200' do
      http_response = double('HTTP Response')
      expect(Excon).to receive(:get).and_return(http_response)
      expect(http_response).to receive(:status).and_return(404).at_least(1)
      expect(http_response).to receive(:body).and_return(api_response_bad_code)

      pclp = PostcodeLookupProxy.new('BR31ES', true)
      expect(pclp.lookup).to be true
      expect(pclp.errors?).to be true
    end
    

    it 'should return true if remote service returns anything other than 2000' do
      http_response = double('HTTPResponse')
      expect(Excon).to receive(:get).and_return(http_response)
      expect(http_response).to receive(:status).and_return(200).at_least(1)
      expect(http_response).to receive(:body).and_return(api_response_bad_code)

      pclp = PostcodeLookupProxy.new('BR31ES', true)
      expect(pclp.lookup).to be true
      expect(pclp.errors?).to be true
    end
  end


  ##### - A test to check that we can connect to the real remote service - don't use in day-to-day testing
  
  describe 'a real lookup to the api' do
    it 'should return a result' do
      WebMock.disable_net_connect!(:allow => [/api.ideal-postcodes.co.uk/, /codeclimate.com/] )
      pclp = PostcodeLookupProxy.new('SW109LB', true)
      expect(pclp).to be_valid
      pclp.lookup
      result = postcode_lookup_valid(pclp)
      expect(result).to be true
      expect(pclp.empty?).to be false
    end
  end
end


def postcode_lookup_valid(pclp)
  result = false
  if (pclp.result_code == 9001 && pclp.result_message == 'Request timed out') && pclp.result_set=='' ||
     (pclp.result_code == 2000 && !pclp.result_set.blank?)
    # return true if valid data returned, or request times out... it's still valid!
    result = true
  end
  result
end

def single_line_address
  api_result = {
          "postcode" =>  "ID1 1QD",
          "postcode_inward" =>  "1QD",
          "postcode_outward" =>  "ID1",
          "post_town" =>  "LONDON",
          "dependant_locality" =>  "",
          "double_dependant_locality" =>  "",
          "thoroughfare" =>  "Barons Court Road",
          "dependant_thoroughfare" =>  "",
          "building_number" =>  "2",
          "building_name" =>  "",
          "sub_building_name" =>  "",
          "po_box" =>  "",
          "department_name" =>  "",
          "organisation_name" =>  "",
          "udprn" =>  25962203,
          "postcode_type" =>  "S",
          "su_organisation_indicator" =>  "",
          "delivery_point_suffix" =>  "1G",
          "line_1" =>  "2 Barons Court Road",
          "line_2" =>  "",
          "line_3" =>  "",
          "premise" =>  "2",
          "country" =>  "England",
          "county" =>  "",
          "district" =>  "Hammersmith and Fulham",
          "ward" =>  "North End",
          "longitude" =>  -0.208644362766368,
          "latitude" =>  51.4899488390558,
          "eastings" =>  524466,
          "northings" =>  178299
    }
end


def three_line_address
  api_result = {
          "postcode" =>  "ID1 1QD",
          "postcode_inward" =>  "1QD",
          "postcode_outward" =>  "ID1",
          "post_town" =>  "LONDON",
          "dependant_locality" =>  "",
          "double_dependant_locality" =>  "",
          "thoroughfare" =>  "Barons Court Road",
          "dependant_thoroughfare" =>  "",
          "building_number" =>  "2",
          "building_name" =>  "",
          "sub_building_name" =>  "",
          "po_box" =>  "",
          "department_name" =>  "",
          "organisation_name" =>  "",
          "udprn" =>  25962203,
          "postcode_type" =>  "S",
          "su_organisation_indicator" =>  "",
          "delivery_point_suffix" =>  "1G",
          "line_1" =>  "Basement Flat",
          "line_2" =>  "Dunroamin",
          "line_3" =>  "5 Barons Court Road",
          "premise" =>  "2",
          "country" =>  "England",
          "county" =>  "",
          "district" =>  "Hammersmith and Fulham",
          "ward" =>  "North End",
          "longitude" =>  -0.208644362766368,
          "latitude" =>  51.4899488390558,
          "eastings" =>  524466,
          "northings" =>  178299
    }
end



def api_response
  %Q/{"result":[{"postcode":"ID1 1QD","postcode_inward":"1QD","postcode_outward":"ID1","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"2","building_name":"","sub_building_name":"","po_box":"","department_name":"","organisation_name":"","udprn":25962203,"postcode_type":"S","su_organisation_indicator":"","delivery_point_suffix":"1G","line_1":"2 Barons Court Road","line_2":"","line_3":"","premise":"2","country":"England","county":"","district":"Hammersmith and Fulham","ward":"North End","longitude":-0.208644362766368,"latitude":51.4899488390558,"eastings":524466,"northings":178299},{"postcode":"ID1 1QD","postcode_inward":"1QD","postcode_outward":"ID1","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"2","building_name":"Basement Flat","sub_building_name":"","po_box":"","department_name":"","organisation_name":"","udprn":52618355,"postcode_type":"S","su_organisation_indicator":"","delivery_point_suffix":"3A","line_1":"Basement Flat","line_2":"2 Barons Court Road","line_3":"","premise":"Basement Flat, 2","country":"England","county":"","district":"Hammersmith and Fulham","ward":"North End","longitude":-0.208644362766368,"latitude":51.4899488390558,"eastings":524466,"northings":178299}],"code":2000,"message":"Success"}/
end


def api_response_bad_code
  %Q/{"result":[{"postcode":"ID1 1QD","postcode_inward":"1QD","postcode_outward":"ID1","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"2","building_name":"","sub_building_name":"","po_box":"","department_name":"","organisation_name":"","udprn":25962203,"postcode_type":"S","su_organisation_indicator":"","delivery_point_suffix":"1G","line_1":"2 Barons Court Road","line_2":"","line_3":"","premise":"2","country":"England","county":"","district":"Hammersmith and Fulham","ward":"North End","longitude":-0.208644362766368,"latitude":51.4899488390558,"eastings":524466,"northings":178299},{"postcode":"ID1 1QD","postcode_inward":"1QD","postcode_outward":"ID1","post_town":"LONDON","dependant_locality":"","double_dependant_locality":"","thoroughfare":"Barons Court Road","dependant_thoroughfare":"","building_number":"2","building_name":"Basement Flat","sub_building_name":"","po_box":"","department_name":"","organisation_name":"","udprn":52618355,"postcode_type":"S","su_organisation_indicator":"","delivery_point_suffix":"3A","line_1":"Basement Flat","line_2":"2 Barons Court Road","line_3":"","premise":"Basement Flat, 2","country":"England","county":"","district":"Hammersmith and Fulham","ward":"North End","longitude":-0.208644362766368,"latitude":51.4899488390558,"eastings":524466,"northings":178299}],"code":4010,"message":"invalid key"}/
end



def expected_result_set
  [
      {"address"=>"1 Melbury Close;;FERNDOWN", "postcode"=>"BH22 8HR"}, 
      {"address"=>"3 Melbury Close;;FERNDOWN", "postcode"=>"BH22 8HR"}, 
      {"address"=>"5 Melbury Close;;FERNDOWN", "postcode"=>"BH22 8HR"}, 
      {"address"=>"7 Melbury Close;;FERNDOWN", "postcode"=>"BH22 8HR"}, 
      {"address"=>"9 Melbury Close;;FERNDOWN", "postcode"=>"BH22 8HR"}, 
      {"address"=>"11 Melbury Close;;FERNDOWN", "postcode"=>"BH22 8HR"}, 
      {"address"=>"13 Melbury Close;;FERNDOWN", "postcode"=>"BH22 8HR"}, 
      {"address"=>"15 Melbury Close;;FERNDOWN", "postcode"=>"BH22 8HR"}, 
      {"address"=>"17 Melbury Close;;FERNDOWN", "postcode"=>"BH22 8HR"}, 
      {"address"=>"19 Melbury Close;;FERNDOWN", "postcode"=>"BH22 8HR"}, 
      {"address"=>"121 Melbury Close;;FERNDOWN", "postcode"=>"BH22 8HR"}, 
      {"address"=>"22 Melbury Close;;FERNDOWN", "postcode"=>"BH22 8H"}, 
      {"address"=>"23 Melbury Close;;FERNDOWN", "postcode"=>"BH22 8HR"}
  ]
end