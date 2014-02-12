require 'spec_helper'

describe ClaimController do
  render_views

  describe "#new" do
    it "should render the new claim form" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe '#confirmation' do
    it 'should render the confirmation page' do
      get :confirmation
      expect(response).to render_template("confirmation")
    end
  end

  describe '#submission' do
    it 'should redirect to the confirmation page' do
      post :submission, claim: claim_post_data['claim']
    end
  end

  describe '#download' do
    it "should return a PDF" do
      get :download, nil, claim: claim_post_data['claim']
      response.headers["Content-Type"].should eq "application/pdf"
    end
  end
end
