describe ClaimantContact do

  def claimant_contact options={}
    params = claim_post_data['claim']['claimant_contact'].merge(options)
    ClaimantContact.new(params)
  end

  describe "when given all valid values" do
    it "should be valid" do
      claimant_contact.should be_valid
    end
  end

  describe "company name" do
    context "when over 60 characters" do
      subject { claimant_contact('company_name' => ("x" * 61)) }

      it { should_not be_valid }
    end

    context "when under 60 characters" do
      subject { claimant_contact('company_name' => ("x" * 60)) }

      it { should be_valid }
    end
  end

  subject { claimant_contact }
  include_examples 'address validation'

  describe 'with non-number legal costs' do
    it 'should be invalid' do
      data = claimant_contact('legal_costs' => 'xx.x')
      data.should_not be_valid
      data.errors.messages[:legal_costs].first.should == 'must be a valid amount'
    end
  end

  describe 'with legal costs no decimal' do
    it 'should be valid' do
      data = claimant_contact('legal_costs' => '123')
      data.should be_valid
      data.legal_costs.should == '123'
    end
  end

  describe 'with blank legal costs' do
    it 'should be valid' do
      data = claimant_contact('legal_costs' => '')
      data.should be_valid
    end
  end

  describe "#as_json" do
    context "when company name isn't supplied" do
      let(:claimant_contact) do
        params = claim_post_data['claim']['claimant_contact']
        params.delete("company_name")
        ClaimantContact.new(params)
      end

      let(:json_output) do
        {
          "address" => "Mr Jim Brown\n3 Smith St\nWinsum",
          "dx_number" => "DX 123",
          "email" => "jim@example.com",
          "fax" => "020 000 000",
          "phone" => "020 000 000",
          "postcode1" => "SW1W",
          "postcode2" => "0LU",
          "reference_number" => "my-ref-123",
          "legal_costs" => '123.34'
        }
      end

      subject { claimant_contact.as_json }

      it { should eq json_output }
    end

    context "when company name is supplied" do
      let(:json_output) do
        {
          "address" => "Mr Jim Brown\nCool company\n3 Smith St\nWinsum",
          "dx_number" => "DX 123",
          "email" => "jim@example.com",
          "fax" => "020 000 000",
          "phone" => "020 000 000",
          "postcode1" => "SW1W",
          "postcode2" => "0LU",
          "reference_number" => "my-ref-123",
          "legal_costs" => '123.34'
        }
      end

      subject { claimant_contact('company_name' => 'Cool company').as_json }

      it { should eq json_output }
    end
  end

end
