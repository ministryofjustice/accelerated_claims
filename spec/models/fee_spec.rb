describe Fee, :type => :model do
  let(:fee) { Fee.new(court_fee: court_fee, fee_account: fee_account) }

  subject { fee }

  context "with blank court fee" do
    let(:court_fee) { "" }
    let(:fee_account) { '' }

    it { is_expected.to be_valid }
    it { expect(fee.court_fee).to eq "280.00"  }

    it { expect(fee.as_json).to eq("court_fee" => "280.00", "fee_account"=>"") }
  end

  context "with a random court fee" do
    let(:court_fee) { 250 }
    let(:fee_account) { '' }

    it { is_expected.to be_valid }
    it { expect(fee.court_fee).to eq "280.00"  }

    it { expect(fee.as_json).to eq("court_fee" => "280.00", "fee_account"=>"") }
  end

  context 'with a fee account number' do
    let(:fee_account) { 9876543210 }
    let(:court_fee) { 250 }

    it { is_expected.to be_valid }
  end

  context 'with a short account number' do
    let(:fee_account) { '1234' }
    let(:court_fee) { 250 }

    it 'is expected to be zero padded' do
      expect(fee).to be_valid
      expect(fee.fee_account).to eq '0000001234'
    end
  end

end
