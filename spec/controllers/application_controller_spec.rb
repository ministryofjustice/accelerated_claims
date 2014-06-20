describe ApplicationController, :type => :controller do

  describe "heartbeat" do
    it "should render the new claim form" do
      get :heartbeat
      expect(response.status).to eq(200)
      expect(response.body).to eq('')
    end
  end
end
