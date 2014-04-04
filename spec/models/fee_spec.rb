describe Fee do
  let(:fee) { Fee.new(court_fee: court_fee) }

  subject { fee }

  context "with blank court fee" do
    let(:court_fee) { "" }

    it { should be_valid }
    its(:court_fee) { should == "175.00" }

    its(:as_json) { should == { "court_fee" => "175.00" } }
  end

  context "with a random court fee" do
    let(:court_fee) { 250 }

    it { should be_valid }
    its(:court_fee) { should == "175.00" }

    its(:as_json) { should == { "court_fee" => "175.00" } }
  end

end
