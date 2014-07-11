shared_examples 'address validation' do

  context 'street is over 70 characters' do
    it 'is invalid' do
      subject.street = "x" * 71
      expect(subject).not_to be_valid
      expect(subject.errors.full_messages).to eq(["Street is too long (maximum is 70 characters)"])
    end
  end

  context 'postcode over 8 characters' do
    it "is invalid" do
      subject.postcode = "x" * 9
      expect(subject).not_to be_valid
    end
  end

  context 'invalid postcode' do
    it 'is invalid' do
      subject.postcode = "n1 12dt"
      expect(subject).not_to be_valid
      expect(subject.errors.full_messages).to eq(["Postcode not valid postcode"])
    end
  end

  context 'too short postcode' do
    it 'is invalid' do
      subject.postcode = "n1"
      expect(subject).not_to be_valid
      expect(subject.errors.full_messages).to eq(["Postcode not full postcode"])
    end
  end

  context 'missing postcode' do
    it 'is invalid' do
      subject.postcode = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:postcode]).to eq( [ "Enter the postcode"] )
    end
  end

  context 'missing address' do
    it 'is invalid' do
      subject.street = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:street]).to eq( [ "Enter the full address"] )
    end
  end
end
