
describe PostcodeLookupProxyController, :type => :controller do

  before(:all) do
    @result_set = YAML.load_file("#{Rails.root}/config/dummy_postcode_results.yml")
  end

  describe "show" do
    context 'a valid postcode' do
      it "should render the result set" do
        get :show, format: :json, pc: "SW10 2LB"
        expect(response.status).to eq(200)
        expect(response.body).to eq @result_set[2].to_json
      end
    end

    context 'an invalid postcode' do
      it "should render 'invalid postcode'" do
        get :show, format: :json, pc: 'Sw10XX6ete'
        expect(response.status).to eq 200
        expect(response.body).to eq "Invalid postcode"
      end
    end


    context 'an empty dataset' do
      it "should render 'No matching postcodes'" do
        get :show, format: :json, pc: 'RG2 0PU'
        expect(response.status).to eq 200
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