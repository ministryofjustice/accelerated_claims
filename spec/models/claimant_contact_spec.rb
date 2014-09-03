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

    let(:expected_email_error)    { ['Enter a valid email address'] }
    
    it 'should not validate eamil addresses with no @ sign' do
      params = claim_post_data['claim']['claimant_contact'].merge('email' => 'joe.blow.example.com')
      claimant_contact = ClaimantContact.new(params) 
      expect(claimant_contact).not_to be_valid
      expect(claimant_contact.errors[:email]).to eq expected_email_error
    end


    it 'should not validate eamil addresses with space' do
      params = claim_post_data['claim']['claimant_contact'].merge('email' => 'joe blow@example.com')
      claimant_contact = ClaimantContact.new(params) 
      expect(claimant_contact).not_to be_valid
      expect(claimant_contact.errors[:email]).to eq expected_email_error
    end

    it 'should not validate eamil addresses with no tld' do
      params = claim_post_data['claim']['claimant_contact'].merge('email' => 'joe blow@examplecom')
      claimant_contact = ClaimantContact.new(params) 
      expect(claimant_contact).not_to be_valid
      expect(claimant_contact.errors[:email]).to eq expected_email_error
    end

    it 'should not validate email addresses with two @' do
      params = claim_post_data['claim']['claimant_contact'].merge('email' => 'joe@blow@examplecom')
      claimant_contact = ClaimantContact.new(params) 
      expect(claimant_contact).not_to be_valid
      expect(claimant_contact.errors[:email]).to eq expected_email_error
    end


    it 'should not accept domain names without a tld' do
      params = claim_post_data['claim']['claimant_contact'].merge('email' => 'joe.blow@examplecom')
      claimant_contact = ClaimantContact.new(params) 
      expect(claimant_contact).not_to be_valid
      expect(claimant_contact.errors[:email]).to eq expected_email_error
    end

    it 'should accept domain anmes with multiple periods' do
      params = claim_post_data['claim']['claimant_contact'].merge('email' => 'joe.blow@example.best.practivce.gov.uk')
      claimant_contact = ClaimantContact.new(params) 
      expect(claimant_contact).to be_valid
    end


    it 'should not validate email addresses with colons' do
      params = claim_post_data['claim']['claimant_contact'].merge('email' => 'joe:blow@examplecom')
      claimant_contact = ClaimantContact.new(params) 
      expect(claimant_contact).not_to be_valid
      expect(claimant_contact.errors[:email]).to eq expected_email_error
    end

    it 'should be valid if there is no email address present' do
      params = claim_post_data['claim']['claimant_contact'].merge('email' => '')
      claimant_contact = ClaimantContact.new(params) 
      expect(claimant_contact).to be_valid
    end

  end


  context 'validate postcode' do
    it 'should be invalid if postcode is too short' do
      params = claim_post_data['claim']['claimant_contact'].merge(:postcode => 'sw10')
      cc = ClaimantContact.new(params)
      expect(cc).not_to be_valid
      expect(cc.errors.full_messages).to eq( [ "Postcode Claimant Contact's postcode is not a full postcode" ] )
    end

    it 'should invalid if postcode not valid postcode' do
      params = claim_post_data['claim']['claimant_contact'].merge(:postcode => 'sw109733')
      cc = ClaimantContact.new(params)
      expect(cc).not_to be_valid
      expect(cc.errors.full_messages).to eq( [ "Postcode Enter a valid postcode for Claimant Contact" ] )
    end
  end


  context 'incomplete alternative address' do
    it 'should be valid if no fields are present' do
      cc = ClaimantContact.new
      expect(cc.valid?).to be true
    end

    it 'should be valid if all fields present' do
      params = claim_post_data['claim']['claimant_contact']
      cc = ClaimantContact.new(params)
      expect(cc).to be_valid
    end

    context 'partial title and full name' do
      it 'should not be valid if name is specified without title' do
        params = claim_post_data['claim']['claimant_contact'].merge(:title => '')
        cc = ClaimantContact.new(params)
        expect(cc).not_to be_valid 
        expect(cc.errors.full_messages).to eq( [ "Title must be present if full_name has been entered" ] )
      end

      it 'should not be valid if title is specified without full name' do
        params = claim_post_data['claim']['claimant_contact'].merge(:full_name => '')
        cc = ClaimantContact.new(params)
        expect(cc).not_to be_valid 
        expect(cc.errors.full_messages).to eq( [ "Full name must be present if title has been entered" ] )
      end
    end

    context 'company specified' do
      it 'should be valid without title and full name' do
        params = claim_post_data['claim']['claimant_contact'].merge(:title => '', :full_name => '')
        cc = ClaimantContact.new(params)
        expect(cc).to be_valid 
      end
    end


    context 'missing name and company' do
      it 'should not be valid if the address is present and there is no name or company' do
        params = claim_post_data['claim']['claimant_contact'].merge(:title => '', :full_name => '', :company_name => '')
        cc = ClaimantContact.new(params)
        expect(cc).not_to be_valid 
        expect(cc.errors.full_messages).to eq( [ 
                "Street cannot be entered if no company or title and full name have been entered", 
                 "Postcode cannot be entered if no company or title and full name have been entered"
          ] )
      end
    end

    context 'missing or partial address' do
      it 'should not be valid if street  and postcode is missing' do
        params = claim_post_data['claim']['claimant_contact'].merge(:street => '', :postcode => '')
        cc = ClaimantContact.new(params)
        expect(cc).not_to be_valid 
        expect(cc.errors.full_messages).to eq( [ 
                  "Street must be present if name and/or company has been specified",
                  "Postcode must be present if name and/or company has been specified"
           ] )
      end


      it 'should not be valid if street is missing' do
        params = claim_post_data['claim']['claimant_contact'].merge(:street => '')
        cc = ClaimantContact.new(params)
        expect(cc).not_to be_valid 
        expect(cc.errors.full_messages).to eq( ["Street must be entered", "Street must be present if name and/or company has been specified"] )
      end

      it 'should not be valid if postcode is missing' do
        params = claim_post_data['claim']['claimant_contact'].merge(:postcode => '')
        cc = ClaimantContact.new(params)
        expect(cc).not_to be_valid 
        expect(cc.errors.full_messages).to eq( ["Postcode must be entered", "Postcode must be present if name and/or company has been specified"] )
      end
    end




  end



  subject { claimant_contact }

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
