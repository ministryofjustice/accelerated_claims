describe Claim, :type => :model do

  let(:claim) do
    Claim.new(data)
  end

  subject { claim }

  describe 'form_state' do
    let(:data) do
      claim_post_data['claim'].merge( 'form_state' => 'some state' )
    end

    its(:form_state) { should == 'some state' }
  end

  describe '#initialize' do
    let(:data) { {} }

    it 'should have submodels' do
      %w(property claimant_one claimant_two notice license deposit
         fee possession order defendant_one defendant_two).each do |attr|
        expect(claim).to respond_to attr
      end
    end
  end

  describe "fixture data" do
    let(:data) { claim_post_data['claim'] }

    it "creates a valid claim" do
      expect(claim).to be_valid
    end
  end

  describe '#as_json' do
    context "when both claim fee & legal cost are known" do
      let(:data) { claim_post_data['claim'] }
      let(:desired_format) { claim_formatted_data }

      it 'should return the right JSON' do
        assert_hash_is_correct claim.as_json, desired_format
      end

      it 'should set demoted tenancy boolean on tenancy' do
        expect(claim.tenancy.demoted_tenancy?).to be false
      end
    end

    describe "when it is a demoted tenancy" do
      describe "when demotion order & county court are filled in" do
        let(:data) { demoted_claim_post_data['claim'] }
        let(:desired_format) { demoted_claim_formatted_data }

        it "should have no values for tenancy agreement reissued fields" do
          ["tenancy_agreement_reissued_for_same_property",
           "tenancy_agreement_reissued_for_same_landlord_and_tenant"].each do |field|
            expect("#{field}: #{claim.as_json[field]}").to eql "#{field}: "
          end
        end

        it 'should return the right JSON' do
          assert_hash_is_correct claim.as_json, desired_format
        end
      end
    end

    describe "when it isn't a demoted tenancy" do
      context "and there is only one tenancy agreement" do
        let(:data) do
          claim = claim_post_data['claim']
          claim["tenancy"]["tenancy_type"] = 'assured'
          claim["tenancy"]["demotion_order_date(3i)"] = ''
          claim["tenancy"]["demotion_order_date(2i)"] = ''
          claim["tenancy"]["demotion_order_date(1i)"] = ''
          claim["tenancy"]["demotion_order_court"] = ''
          claim["tenancy"]['start_date'] = Date.parse("2010-01-01"),
          claim["tenancy"]['assured_shorthold_tenancy_notice_served_by'] = ''
          claim
        end

        let(:desired_format) do
          format = claim_formatted_data
          format["tenancy_demoted_tenancy"] = 'No'
          format["tenancy_demotion_order_court"] = ""
          format["tenancy_demotion_order_date_day"] = ""
          format["tenancy_demotion_order_date_month"] = ""
          format["tenancy_demotion_order_date_year"] = ""
          format["tenancy_agreement_reissued_for_same_property"] = 'NA'
          format["tenancy_agreement_reissued_for_same_landlord_and_tenant"] = 'NA'
          format["tenancy_assured_shorthold_tenancy_notice_served_by_name"] = ""
          format["tenancy_assured_shorthold_tenancy_notice_served_method"] = ""
          format["tenancy_assured_shorthold_tenancy_notice_served_date_day"] = ""
          format["tenancy_assured_shorthold_tenancy_notice_served_date_month"] = ""
          format["tenancy_assured_shorthold_tenancy_notice_served_date_year"] = ""
          format["tenancy_latest_agreement_date_day"] = ""
          format["tenancy_latest_agreement_date_month"] = ""
          format["tenancy_latest_agreement_date_year"] = ""
          format
        end

        context "and it's the only tenancy" do
          it 'should return the right JSON' do
            skip 'should agreement_reissued_for_same_property be "NA"? - check with Kellie'
            assert_hash_is_correct claim.as_json, desired_format
          end
        end
      end

      context "and there is more than one tenancy agreement" do
        let(:data) do
          claim = claim_post_data['claim']
          claim["tenancy"]["tenancy_type"] = 'assured'
          claim["tenancy"]["demotion_order_date(3i)"] = ''
          claim["tenancy"]["demotion_order_date(2i)"] = ''
          claim["tenancy"]["demotion_order_date(1i)"] = ''
          claim["tenancy"]["demotion_order_court"] = ''
          claim["tenancy"]["latest_agreement_date"] = Date.parse("2010-01-01")
          claim
        end

        let(:desired_format) do
          format = claim_formatted_data
          format["tenancy_demoted_tenancy"] = 'No'
          format["tenancy_demotion_order_court"] = ""
          format["tenancy_demotion_order_date_day"] = ""
          format["tenancy_demotion_order_date_month"] = ""
          format["tenancy_demotion_order_date_year"] = ""
          format["tenancy_agreement_reissued_for_same_property"] = 'No'
          format["tenancy_agreement_reissued_for_same_landlord_and_tenant"] = 'No'
          format
        end

        context "and it's the only tenancy" do
          it 'should return the right JSON' do
            hash = claim.as_json
            assert_hash_is_correct hash, desired_format
          end
        end

        context "and it wasn't reissued for the same property" do
          let(:desired_format) do
            format = claim_formatted_data
            format["tenancy_demoted_tenancy"] = 'No'
            format["tenancy_demotion_order_court"] = ""
            format["tenancy_demotion_order_date_day"] = ""
            format["tenancy_demotion_order_date_month"] = ""
            format["tenancy_demotion_order_date_year"] = ""
            format["tenancy_agreement_reissued_for_same_property"] = 'No'
            format["tenancy_agreement_reissued_for_same_landlord_and_tenant"] = 'No'
            format
          end

          context "and it's the only tenancy" do
            it 'should return the right JSON' do
              assert_hash_is_correct claim.as_json, desired_format
            end
          end
        end

        context "and it is reissued for the same property" do
          let(:data) do
            claim = claim_post_data['claim']
            claim["tenancy"]["tenancy_type"] = 'assured'
            claim["tenancy"]["demotion_order_date(3i)"] = ''
            claim["tenancy"]["demotion_order_date(2i)"] = ''
            claim["tenancy"]["demotion_order_date(1i)"] = ''
            claim["tenancy"]["demotion_order_court"] = ''
            claim["tenancy"]["latest_agreement_date"] = Date.parse("2010-01-01")
            claim["tenancy"]["latest_agreement_date"] = Date.parse("2010-01-01")
            claim["tenancy"]["agreement_reissued_for_same_property"] = 'Yes'
            claim
          end

          let(:desired_format) do
            format = claim_formatted_data
            format["tenancy_demoted_tenancy"] = 'No'
            format["tenancy_demotion_order_court"] = ""
            format["tenancy_demotion_order_date_day"] = ""
            format["tenancy_demotion_order_date_month"] = ""
            format["tenancy_demotion_order_date_year"] = ""
            format["tenancy_agreement_reissued_for_same_property"] = 'Yes'
            format["tenancy_agreement_reissued_for_same_landlord_and_tenant"] = 'No'
            format
          end

          context "and it's the only tenancy" do
            it 'should return the right JSON' do
              assert_hash_is_correct claim.as_json, desired_format
            end
          end

          context "and it's reissued for the same landlord and tenant" do
            let(:data) do
              claim = claim_post_data['claim']
              claim["tenancy"]["tenancy_type"] = 'assured'
              claim["tenancy"]["demotion_order_date(3i)"] = ''
              claim["tenancy"]["demotion_order_date(2i)"] = ''
              claim["tenancy"]["demotion_order_date(1i)"] = ''
              claim["tenancy"]["demotion_order_court"] = ''
              claim["tenancy"]["latest_agreement_date"] = Date.parse("2010-01-01")
              claim["tenancy"]["latest_agreement_date"] = Date.parse("2010-01-01")
              claim["tenancy"]["agreement_reissued_for_same_property"] = 'Yes'
              claim["tenancy"]["agreement_reissued_for_same_landlord_and_tenant"] = 'Yes'
              claim
            end

            let(:desired_format) do
              format = claim_formatted_data
              format["tenancy_demoted_tenancy"] = 'No'
              format["tenancy_demotion_order_court"] = ""
              format["tenancy_demotion_order_date_day"] = ""
              format["tenancy_demotion_order_date_month"] = ""
              format["tenancy_demotion_order_date_year"] = ""
              format["tenancy_agreement_reissued_for_same_property"] = 'Yes'
              format["tenancy_agreement_reissued_for_same_landlord_and_tenant"] = 'Yes'
              format
            end

            context "and it's the only tenancy" do
              it 'should return the right JSON' do
                assert_hash_is_correct claim.as_json, desired_format
              end
            end
          end
        end
      end
    end

    context "when only claim fee is known" do
      let(:data) do
        hash = claim_post_data['claim']
        hash['legal_cost'].delete('legal_costs')
        hash
      end

      it 'should return the total cost' do
        expect(claim.as_json).to include "total_cost"
      end

      it 'should match total fee' do
        expect(claim.as_json["total_cost"]).to eq claim.as_json["fee_court_fee"]
      end
    end

    context "when a defendant's address is blank" do
      let(:data) do
        hash = claim_post_data['claim']
        hash['defendant_one'] = hash['defendant_one'].except('street', 'postcode')
        hash['defendant_two'] = hash['defendant_two'].except('street', 'postcode')
        hash
      end
      it "dependant one should render with the property's address" do
        expect(claim.as_json['defendant_one_address']).to include claim.as_json['property_address']
        expect(claim.as_json['defendant_one_postcode1']).to eql claim.as_json['property_postcode1']
        expect(claim.as_json['defendant_one_postcode2']).to eql claim.as_json['property_postcode2']
      end
      it "defendant two should render with the property's address" do
        expect(claim.as_json['defendant_two_address']).to include claim.as_json['property_address']
        expect(claim.as_json['defendant_one_postcode1']).to eql claim.as_json['property_postcode1']
        expect(claim.as_json['defendant_one_postcode2']).to eql claim.as_json['property_postcode2']
      end
    end


    context 'num_claimants is 1' do
      let(:data) do
        mydata = claim_post_data['claim'] 
        mydata['num_claimants'] = 1
        mydata
      end

      it 'should be invalid when claimant 2 data is given' do
        claim = Claim.new(data)
        expect(claim).to_not be_valid
        expect(claim.claimant_two.errors.messages[:full_name]).to eq ['must not be entered if number of claimants is 1']
        expect(claim.claimant_two.errors.messages[:street]).to eq ['must not be entered if number of claimants is 1']
        expect(claim.claimant_two.errors.messages[:postcode]).to eq ['must not be entered if number of claimants is 1']
      end

      it 'should be invalid when there is no claimant 1 data' do
        data[:claimant_one] = { "title"=>"", "full_name"=>"", "street"=>"", "postcode"=>""} 
        claim = Claim.new(data)
        expect(claim).to_not be_valid
        expect(claim.claimant_one.errors.messages[:full_name]).to eq ['must be entered']
        expect(claim.claimant_one.errors.messages[:street]).to eq ['must be entered']
        expect(claim.claimant_one.errors.messages[:postcode]).to eq ['must be entered']
      end
     
      it 'should be valid if there is claimant 1 data and no claimant 2 data' do
        data.delete(:claimant_two)
        claim = Claim.new(data)
        expect(claim).to be_valid
      end

      it 'should be valid if there is claimant one data and  claimant two data is all blank' do
        data[:claimant_two] = { "title"=>"", "full_name"=>"", "street"=>"", "postcode"=>""} 
        claim = Claim.new(data)
        expect(claim).to be_valid
      end
    end
    
    context 'num_claimants is 2' do
      let(:data)     { claim_post_data['claim']  }
      let(:claim)    { Claim.new(data) }

      it 'should be valid when both claimants details are present' do
        expect(claim).to be_valid
      end


      it 'should not be valid when no details are present for claimant 2' do
        data.delete(:claimant_two)
        expect(claim).to_not be_valid
        expect(claim.errors.full_messages).to eq [["claim_claimant_two_full_name_error", "Full name must be entered"], ["claim_claimant_two_street_error", "Street must be entered"], ["claim_claimant_two_postcode_error", "Postcode must be entered"]]
      end

      it 'should not be valid when the details for claimant 2 are blank' do
        data["claimant_two"].each { |k, v| data["claimant_two"][k] = '' }
        expect(claim).to_not be_valid
        expect(claim.errors.full_messages).to eq [["claim_claimant_two_full_name_error", "Full name must be entered"], ["claim_claimant_two_street_error", "Street must be entered"], ["claim_claimant_two_postcode_error", "Postcode must be entered"]]
      end
    end

    context 'num_claimants is not specified' do

      let(:data) do
        mydata = claim_post_data['claim'] 
        mydata.delete('num_claimants')
        mydata
      end

      it 'should not be valid' do
        expect(data[:num_claimants]).to be_nil
        expect(claim).to_not be_valid
      end


    end

    context 'invalid num claimants' do

      let(:data)  { claim_post_data['claim'] }

      it 'should not be valid if the num claimants is 3' do
        data[:num_claimants] = 3
        expect(claim).to_not be_valid
        expect(claim.errors.full_messages).to eq ["Num claimants must be specified"]
      end
    end
  end
end
