shared_examples 'address validation' do

  context 'street is over 70 characters' do
    it 'is invalid' do
      subject.street = "x" * 71
      subject.should_not be_valid
      subject.errors.full_messages.should == ["Street is too long (maximum is 70 characters)"]
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

  context 'missing postcode' do
    it 'is invalid' do
      subject.postcode = nil
      subject.should_not be_valid
      subject.errors.full_messages.should == ["Postcode must be entered"]
    end
  end

  context 'missing address' do
    it 'is invalid' do
      subject.street = nil
      subject.should_not be_valid
      subject.errors.full_messages.should == ["Street must be entered"]
    end
  end
end
