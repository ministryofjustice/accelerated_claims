describe ContactController, :type => :controller do

  describe "#new" do
    it "should render the new feedback form" do
      get :new
      expect(response).to render_template("new")
    end
  end

end
