describe Fee, :type => :model do
  let(:fee) { Fee.new(court_fee: court_fee, account: account) }

  subject { fee }

  context "with blank court fee" do
    let(:court_fee) { "" }
    let(:account) { '' }

    it { is_expected.to be_valid }
    it { expect(fee.court_fee).to eq "280"  }

    it { expect(fee.as_json).to eq("court_fee" => "280", "account"=>"") }
  end

  context "with a random court fee" do
    let(:court_fee) { 250 }
    let(:account) { '' }

    it { is_expected.to be_valid }
    it { expect(fee.court_fee).to eq "280"  }

    it { expect(fee.as_json).to eq("court_fee" => "280", "account"=>"") }
  end

  context 'with a fee account number' do
    let(:court_fee) { "" }
    let(:account) { 9876543210 }

    it { is_expected.to be_valid }
    it { expect(fee.as_json).to eq("court_fee" => "280.00", "account"=>"9876543210") }
  end

  context 'with a short account number' do
    let(:court_fee) { "" }
    let(:account) { '1234' }
    it { is_expected.to be_valid }
    it { expect(fee.as_json).to eq("court_fee" => "280.00", "account"=>"0000001234") }
  end

  context 'with non numeric account number' do
    let(:court_fee) { "" }
    let(:account) { 'bob' }

    it "shouldn't be valid" do
      expect(fee).not_to be_valid
      expect(fee.errors[:account]).to eq ["Your fee account number should contain numbers only"]
    end
  end

  context 'with partially non numeric account number' do
    let(:court_fee) { "" }
    let(:account) { 'bob123' }

    it "shouldn't be valid" do
      expect(fee).not_to be_valid
      expect(fee.errors[:account]).to eq ["Your fee account number should contain numbers only"]
    end
  end

  context 'with partially non numeric account number' do
    let(:court_fee) { "" }
    let(:account) { '123bob' }

    it "shouldn't be valid" do
      expect(fee).not_to be_valid
      expect(fee.errors[:account]).to eq ["Your fee account number should contain numbers only"]
    end
  end

end
