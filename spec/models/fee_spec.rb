describe Fee, :type => :model do
  let(:fee) { Fee.new(court_fee: court_fee) }

  subject { fee }

  context "with blank court fee" do
    let(:court_fee) { "" }

    it { is_expected.to be_valid }
    its(:court_fee) { should == "280.00" }

    its(:as_json) { should == { "court_fee" => "280.00" } }
  end

  context "with a random court fee" do
    let(:court_fee) { 250 }

    it { is_expected.to be_valid }
    its(:court_fee) { should == "280.00" }

    its(:as_json) { should == { "court_fee" => "280.00" } }
  end

end
