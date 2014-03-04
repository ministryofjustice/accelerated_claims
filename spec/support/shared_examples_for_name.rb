shared_examples 'name validation' do

  context 'full_name is blank' do
    it "is invalid" do
      subject.full_name = ""
      subject.should_not be_valid
      subject.errors.full_messages.should == ["Full name must be entered"]
    end
  end

end
