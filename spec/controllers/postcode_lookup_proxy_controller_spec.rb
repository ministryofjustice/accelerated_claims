
describe PostcodeLookupProxyController, :type => :controller do

  before(:all) do
    @result_set = YAML.load_file("#{Rails.root}/config/dummy_postcode_results.yml")
  end

  describe "show" do
    context 'a valid postcode' do
      it "should render the result set" do
        get :show, format: :json, pc: "SW10 2LB"
        expect(response.status).to eq(200)
        expect(response.body).to eq expected_response
      end
    end

    context 'an invalid postcode' do
      it "should render 'invalid postcode'" do
        get :show, format: :json, pc: 'Sw10XX6ete'
        expect(response.status).to eq 422
        expect(response.body).to eq "Invalid postcode"
      end
    end


    context 'an empty dataset' do
      it "should render 'No matching postcodes'" do
        get :show, format: :json, pc: 'RG2 0PU'
        expect(response.status).to eq 404
        expect(response.body).to eq "No matching postcodes"
      end
    end

    context 'a remote timeout or failure' do
      it 'should return status service unavailable (503)' do
        pclp = double('PostcodeLookupProxy')
        expect(PostcodeLookupProxy).to receive(:new).and_return(pclp)
        expect(pclp).to receive(:invalid?).and_return(false)
        expect(pclp).to receive(:lookup).and_return(false)
        get :show, format: :json, pc: 'RG2 7PU'
        expect(response.status).to eq 503
        expect(response.body).to eq 'Service not available'
      end
    end
  end


end



def expected_response
  [
    {"address"=>"150 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"152 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"154 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"156 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"158 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"160 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"162 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"164 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"166 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"168 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"170 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"172 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"174 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"176 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"178 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"180 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"182 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"184 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"186 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"188 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"190 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"},
    {"address"=>"192 Northumberland Avenue;;READING", "postcode"=>"RG2 7PU"}
  ].to_json
end