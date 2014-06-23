shared_examples 'name validation' do

  context 'full_name is blank' do
    it "is invalid" do
      subject.full_name = ""
      expect(subject).not_to be_valid
      expect(subject.errors.full_messages).to eq(["Full name must be entered"])
    end
  end

end
