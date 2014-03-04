shared_examples 'address validation' do

  context "street blank" do
    it "is invalid" do
      if !subject.is_a?(ClaimantContact) && (!subject.respond_to?(:validate_presence) || (subject.validate_presence && !subject.is_a?(Defendant)) )
        subject.street = ""
        subject.should_not be_valid
      end
    end
  end

  context "town over 40 characters" do
    it "is invalid" do
      subject.town = "x" * 41
      subject.should_not be_valid
    end
  end

  context 'street is over 70 characters' do
    it 'is invalid' do
      subject.street = "x" * 71
      subject.should_not be_valid
      subject.errors.full_messages.should == ["Street is too long (maximum is 70 characters)"]
    end
  end

  context "postcode blank" do
    it "is invalid" do
      if !subject.is_a?(ClaimantContact) && (!subject.respond_to?(:validate_presence) || (subject.validate_presence && !subject.is_a?(Defendant)) )
        subject.postcode = ""
        if subject.is_a?(Defendant)
          binding.pry
        end
        subject.should_not be_valid
      end
    end
  end

  context 'postcode over 8 characters' do
    it "is invalid" do
      subject.postcode = "x" * 9
      subject.should_not be_valid
    end
  end

  context 'invalid postcode' do
    it 'is invalid' do
      subject.postcode = "n1 12dt"
      subject.should_not be_valid
      subject.errors.full_messages.should == ["Postcode not valid postcode"]
    end
  end

  context 'too short postcode' do
    it 'is invalid' do
      subject.postcode = "n1"
      subject.should_not be_valid
      subject.errors.full_messages.should == ["Postcode not full postcode"]
    end
  end
end
