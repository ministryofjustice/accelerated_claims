describe "root route", :type => :routing do
  it "routes / to the claim#new" do
    expect(get('/')).to route_to("claim#new")
  end
end
