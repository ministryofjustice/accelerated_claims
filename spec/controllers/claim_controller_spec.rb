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
    it "should return a PDF" do
      claim_hash = { "claim" => { "landlord" => { "company" => "Yey" } } }
      post :submission, claim_hash
      response.headers["Content-Type"].should eq "application/pdf"
    end
  end
end
