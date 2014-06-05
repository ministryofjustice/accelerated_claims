describe ApplicationController do

  describe "heartbeat" do
    it "should render the new claim form" do
      get :heartbeat
      response.status.should == 200
      response.body.should == ''
    end
  end
end
