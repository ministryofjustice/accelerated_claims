shared_examples 'address presence validation' do

  context "street blank" do
    it "is invalid" do
      subject.street = ""
      expect(subject).not_to be_valid
    end
  end

  context "postcode blank" do
    it "is invalid" do
      subject.postcode = ""
      expect(subject).not_to be_valid
    end
  end

end
