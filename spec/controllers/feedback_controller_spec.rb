require 'spec_helper'

describe FeedbackController do
  render_views

  describe "#new" do
    it "should render the new feedback form" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe '#create' do
    it 'should redirect to the homepage' do
      post :create
      assert_redirected_to root_path
    end

    it 'should set the flash message' do
      post :create
      assert_equal 'Thanks for your feedback.', flash[:notice]
    end
  end

end
