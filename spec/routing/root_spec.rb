require "spec_helper"

describe "root route" do
  it "routes / to the claim#landing" do
    expect(get('/')).to route_to("claim#landing")
  end
end
