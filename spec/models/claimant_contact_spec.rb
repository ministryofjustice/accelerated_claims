describe ClaimantContact, :type => :model do

  def claimant_contact options={}
    params = claim_post_data['claim']['claimant_contact'].merge(options)
    ClaimantContact.new(params)
  end

  describe "when given all valid values" do
    it "should be valid" do
      expect(claimant_contact).to be_valid
    end
  end

  describe "company name" do
    context "when over 40 characters" do
      subject { claimant_contact('company_name' => ("x" * 41)) }

      it { is_expected.not_to be_valid }
    end

    context "when under 40 characters" do
      subject { claimant_contact('company_name' => ("x" * 40)) }

      it { is_expected.to be_valid }
    end
  end



  context 'email_validation' do
    
    it 'should not validate eamil addresses with no @ sign' do
      params = claim_post_data['claim']['claimant_contact'].merge('email' => 'joe.blow.example.com')
      claimant_contact = ClaimantContact.new(params) 
      puts "++++++ DEBUG notice ++++++ #{__FILE__}::#{__LINE__} ++++\n"
      pp claimant_contact
      expect(claimant_contact).not_to be_valid
      pp claimant_contact.errors.full_messages
      expect(claimant_contact.errors.full_messages.include?('Email address is not valid')).to be true
    end


    it 'should not validate eamil addresses with space' do
      params = claim_post_data['claim']['claimant_contact'].merge('email' => 'joe blow@example.com')
      claimant_contact = ClaimantContact.new(params) 
      expect(claimant_contact).not_to be_valid
      expect(claimant_contact.errors.full_messages.include?('Email address is not valid')).to be true
    end

    it 'should not validate eamil addresses with no tld' do
      params = claim_post_data['claim']['claimant_contact'].merge('email' => 'joe blow@examplecom')
      claimant_contact = ClaimantContact.new(params) 
      expect(claimant_contact).not_to be_valid
      expect(claimant_contact.errors.full_messages.include?('Email address is not valid')).to be true
    end

    it 'should not validate email addresses with two @' do
      params = claim_post_data['claim']['claimant_contact'].merge('email' => 'joe@blow@examplecom')
      claimant_contact = ClaimantContact.new(params) 
      expect(claimant_contact).not_to be_valid
      expect(claimant_contact.errors.full_messages.include?('Email address is not valid')).to be true
     end


     it 'should not validate email addresses with colons' do
      params = claim_post_data['claim']['claimant_contact'].merge('email' => 'joe:blow@examplecom')
      claimant_contact = ClaimantContact.new(params) 
      expect(claimant_contact).not_to be_valid
      expect(claimant_contact.errors.full_messages.include?('Email address is not valid')).to be true
     end

  end



  subject { claimant_contact }
  include_examples 'address validation'

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
          "postcode2" => "0LU"
        }
      end

      subject { claimant_contact.as_json }

      it { is_expected.to eq json_output }
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
          "postcode2" => "0LU"
        }
      end

      subject { claimant_contact('company_name' => 'Cool company').as_json }

      it { is_expected.to eq json_output }
    end
  end

end
