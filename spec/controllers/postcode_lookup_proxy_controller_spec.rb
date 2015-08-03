describe PostcodeLookupProxyController, :type => :controller do

  describe "show" do

    before(:all) do
      @result_set = YAML.load_file("#{Rails.root}/config/dummy_postcode_results.yml")
      setenv 'demo'
    end

    after(:all) { resetenv }

    before(:example) do
      allow(controller).to receive(:live_postcode_lookup?).and_return(false)
    end

    context 'a valid postcode' do
      it "should render the result set" do
        get :show, format: :json, pc: "SW10 2LB", vc: 'all'
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq JSON.parse(expected_response)
      end
    end

    context 'an invalid postcode' do
      it "should render 'invalid postcode'" do
        get :show, format: :json, pc: 'Sw10XX6ete', vc: 'all'
        expect(response.status).to eq 422
        expect(JSON.parse(response.body)).to eq({'code' => 4220, 'message' => 'Invalid Postcode'})
      end
    end

    context 'an empty dataset' do
      it "should render 'No matching postcodes'" do
        get :show, format: :json, pc: 'RG2 0PU', vc: 'all'
        expect(response.status).to eq 404
        expect(JSON.parse(response.body)).to eq({'code' => 4040, 'message' => 'Postcode Not Found'})
      end
    end

    context 'a remote timeout or failure' do
      it 'should return status service unavailable (503)' do
        # simulate a timeout on a live lookup
        allow(controller).to receive(:live_postcode_lookup?).and_return(true)
        allow_any_instance_of(PostcodeInfo::Client).to receive(:lookup_postcode).and_raise(Timeout::Error)
        get :show, format: :json, pc: 'RG2 7PU', vc: 'all'
        expect(response.status).to eq 503
        expect(JSON.parse(response.body)).to eq({'code' => 5030, 'message' => 'Service Unavailable'})
      end
    end

    context 'a scottish postcode which is allowed' do
      it 'should call proxy with and emtpy array and return a valid set of addresses' do
        #expect(PostcodeLookupProxy).to receive(:new).with('EH10 5LB', ['All'], false).and_call_original
        get :show, format: :json, pc: "EH10 5LB", vc: 'all'
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq JSON.parse(scottish_response)
      end
    end

    context 'a scottish postcode which is not allowed' do
      it 'should return 200 with 4041 result code and scotland as message' do
        #expect(PostcodeLookupProxy).to receive(:new).with('EH10 5LB', ['England', 'Wales'], false).and_call_original
        get :show, format: :json, pc: "EH10 5LB", vc: 'england wales'
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq({'code' => 4041, 'message' => 'Scotland' })
      end
    end
  end

  describe 'live_postcode_lookup' do

    # This test queries the live server and so should be used in normal day to day usage, but is
    # here if there is a question over what the live server actually returns
    #
    if ENV['LIVEPC'] == 'idealpostcodes'
      context 'with livepc in url' do
        before(:each) do
          allow(request).to receive(:referer).and_return('https://civilclaims.service.gov.uk/accelerated-possession-eviction?journey=4&livepc=1')
        end

        it 'should return true for demo environments' do
          setenv 'demo'
          expect_postcode_lookup_to_be_called_with(true)
          get :show, format: :json, pc: 'RG2 7PU', vc: 'all'
          resetenv
        end

        it 'should return true for staging environments' do
          setenv 'staging'
          expect_postcode_lookup_to_be_called_with(true)
          get :show, format: :json, pc: 'RG2 7PU', vc: 'all'
          resetenv
        end

        it 'should return true for production environments' do
          setenv 'staging'
          expect_postcode_lookup_to_be_called_with(true)
          get :show, format: :json, pc: 'RG2 7PU', vc: 'all'
          resetenv
        end
      end
    end

    context 'with no livepc in the url' do

      let(:postcode)        { 'RG2 7PU' }
      let(:all_countries)   { ['All'] }

      before(:each) do
        allow(request).to receive(:referer).and_return('https://civilclaims.service.gov.uk/accelerated-possession-eviction?journey=4')
      end

      it 'should return false for demo environments' do
        setenv 'demo1'
        get :show, format: :json, pc: 'RG2 7PU', vc: 'all'
        expect(controller.send(:live_postcode_lookup?)).to eq(false)
        resetenv
      end

      # This test queries the live server and so should be used in normal day to day usage, but is
      # here if there is a question over what the live server actually returns
      #
      if ENV['LIVEPC'] == 'idealpostcodes'

        it 'should return true for staging environments' do
          setenv 'staging'
          get :show, format: :json, pc: 'RG2 7PU', vc: 'all'
          expect(controller.send(:live_postcode_lookup?)).to eq(true)
          resetenv
        end

        it 'should return true for production environments' do
          setenv 'production'
          get :show, format: :json, pc: 'RG2 7PU', vc: 'all'
          expect(controller.send(:live_postcode_lookup?)).to eq(true)
          resetenv
        end
      end
    end
  end
end

def setenv(env)
  ENV['ENV_NAME'] = env
end

def resetenv
  ENV['ENV_NAME'] = nil
end

def set_referer_url_with_use_live_postcode_lookup_param
  allow(request).to receive(:referer).and_return('https://civilclaims.service.gov.uk/accelerated-possession-eviction?journey=4&livepc=1')
end

def set_referer_url_without_use_live_postcode_lookup_param
  allow(request).to receive(:referer).and_return('https://civilclaims.service.gov.uk/accelerated-possession-eviction?journey=4')
end

# def expect_postcode_lookup_to_be_called_with(postcode, *flags)
#   pclp = double(PostcodeLookupProxy).as_null_object
#   expect(PostcodeLookupProxy).to receive(:new).with(postcode, *flags).and_return(pclp)
#   allow(pclp).to receive(:result_set).and_return('xxx')
#   allow(pclp).to receive(:http_status).and_return(200)
# end

def scottish_response
  {
    'code'    => 2000,
    'message' => 'Success',
    'result'  => [
      {'address'=>'134, Corstorphine Road;;EDINBURGH', 'postcode'=>'EH12 6TS', 'country' => 'Scotland'},
      {'address'=>'Royal Zoological Society of Scotland;;134, Corstorphine Road;;EDINBURGH', 'postcode'=>'EH12 6TS', 'country' => 'Scotland'}
    ]
  }.to_json
end

def expected_response
  {
    'code'    => 2000,
    'message' => 'Success',
    'result'  => [
      {'address'=>'150 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'152 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'154 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'156 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'158 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'160 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'162 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'164 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'166 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'168 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'170 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'172 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'174 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'176 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'178 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'180 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'182 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'184 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'186 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'188 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'190 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'},
      {'address'=>'192 Northumberland Avenue;;READING', 'postcode'=>'RG2 7PU', 'country' => 'England'}
    ]
  }.to_json
end
