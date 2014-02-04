require 'spec_helper'

describe ClaimController do
  render_views

  describe "new claim" do
    it "should render the new claim form" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "claim submission" do

    it "accepts claim submission" do
      claim_hash = {}
      post :submission, claim_hash
      response.should redirect_to(thank_you_path)
    end

  end
end
