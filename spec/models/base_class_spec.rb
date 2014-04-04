describe Property do
  let(:bc) { BaseClass.new }

  it "should respond to #attributes" do
    bc.should respond_to(:attributes)
  end

  it "should respond to #as_json" do
    bc.should respond_to(:as_json)
  end
end
