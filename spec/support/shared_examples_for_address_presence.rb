shared_examples 'address presence validation' do

  context "street blank" do
    it "is invalid" do
      subject.street = ""
      subject.should_not be_valid
    end
  end

  context "postcode blank" do
    it "is invalid" do
      subject.postcode = ""
      subject.should_not be_valid
    end
  end

end
