describe PostcodeLookupProxy do

  describe '.new' do
    context 'a valid postcode' do
      it 'should return be valid' do
        pclp = PostcodeLookupProxy.new('WC1B5HA')
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

    it 'should call production lookup if production environment' do
      pc = PostcodeLookupProxy.new('WC1B5HA')
      expect(Rails.env).to receive(:production?).and_return(true)
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
        expect(response).to receive(:status).and_return(200)
        expect(pclp).to receive(:transform_api_response).with(response).and_return("transformed response")

        expect(pclp.send(:production_lookup)).to be true
        expect(pclp.result_set).to eq 'transformed response'
      end
    end

    context 'call to ideal postcodes times out' do
      it 'should return false' do
        pclp = PostcodeLookupProxy.new('SW10 9LN')
        expect(Excon).to receive(:get).and_raise Timeout::Error
        expect(pclp.send(:production_lookup)).to be false
      end
    end


    context "real call to ideal postcocdes" do
      it 'should produce nowt' do
        WebMock.disable_net_connect!(:allow => [/ideal-postcodes/])
        expect(Rails.env).to receive(:production?).and_return(true)
        pclp = PostcodeLookupProxy.new('ID1 1QD')
        expect(pclp.valid?).to be true
        expect(pclp.lookup).to be true
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
      expect(pc.result_set).to eq PostcodeLookupProxy.class_variable_get(:@@dummy_postcode_results)[1]
    end
  end
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