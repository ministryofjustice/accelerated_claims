describe Fee, :type => :model do
  let(:fee) { Fee.new(court_fee: court_fee) }

  subject { fee }

  context "with blank court fee" do
    let(:court_fee) { "" }

    it { is_expected.to be_valid }
    it { expect(fee.court_fee).to eq "280.00"  }

    it { expect(fee.as_json).to eq("court_fee" => "280.00") }
  end

  context "with a random court fee" do
    let(:court_fee) { 250 }

    it { is_expected.to be_valid }
    it { expect(fee.court_fee).to eq "280.00"  }

    it { expect(fee.as_json).to eq("court_fee" => "280.00") }
  end

end
