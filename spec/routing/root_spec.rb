describe "root route", :type => :routing do
  it "routes / to the claim#new" do
    expect(get(root_path)).to route_to("claim#new")
  end
end
