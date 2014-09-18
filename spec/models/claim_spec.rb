describe Claim, :type => :model do

  let(:claim) do
    c = Claim.new(data)
    c.valid?
    c
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
      %w(property notice license deposit fee possession order).each do |attr|
        expect(claim).to respond_to attr
      end
    end
  end

  context 'method_missing' do
    let(:data) { {} }
    it 'should respond to magic methods claimant_n' do
      expect{
        claim.claimant_1
        claim.claimant_2
      }.not_to raise_error
    end

    it 'should respond to magic methods defendant_n' do
      expect{
        claim.defendant_1
        claim.defendant_7
        claim.defendant_20
      }.not_to raise_error
    end

    it 'should return a claimant object for magic methods claimant_n' do
      expect(claim.claimant_4).to be_instance_of(Claimant)
    end

    it 'shuld return a defendant object for magic mehods defendnat_n' do
      expect(claim.defendant_4).to be_instance_of(Defendant)
      expect(claim.defendant_20).to be_instance_of(Defendant)
    end

    it 'should respond to magic mehods defendant_n=' do
      expect(claim.defendants).to receive(:[]=).with(3, nil)
      claim.defendants[3] = nil
    end
  end

  describe "fixture data" do
    let(:data) { claim_post_data['claim'] }

    it "creates a valid claim" do
      expect(claim).to be_valid, claim.errors.full_messages
    end
  end

  describe '#javascript_enabled?' do
    context 'with javascript' do
      it 'should return true' do
        claim = Claim.new(claim_post_data['claim'].merge( 'javascript_enabled' => 'Yes' ))
        expect(claim.javascript_enabled?).to be true
      end
    end

    context 'without javascript' do
      it 'should return false' do
        claim = Claim.new(claim_post_data)
        expect(claim.javascript_enabled?).to be false
      end
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
        hash['defendant_1'] = hash['defendant_1'].except('street', 'postcode')
        hash['defendant_2'] = hash['defendant_2'].except('street', 'postcode')
        hash['defendant_1']["inhabits_property"] = "yes"
        hash['defendant_2']["inhabits_property"] = "yes"
        hash
      end
      it "defendant one should render with the property's address" do
        expect(claim.as_json['defendant_1_address']).to include claim.as_json['property_address']
        expect(claim.as_json['defendant_1_postcode1']).to eql claim.as_json['property_postcode1']
        expect(claim.as_json['defendant_1_postcode2']).to eql claim.as_json['property_postcode2']
      end
      it "defendant two should render with the property's address" do
        expect(claim.as_json['defendant_2_address']).to include claim.as_json['property_address']
        expect(claim.as_json['defendant_1_postcode1']).to eql claim.as_json['property_postcode1']
        expect(claim.as_json['defendant_1_postcode2']).to eql claim.as_json['property_postcode2']
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
        expect(claim.claimant_2.errors.messages[:full_name]).to eq ['must not be entered if number of claimants is 1']
        expect(claim.claimant_2.errors.messages[:street]).to eq ['must not be entered if number of claimants is 1']
        expect(claim.claimant_2.errors.messages[:postcode]).to eq ['must not be entered if number of claimants is 1']
      end

      it 'should be invalid when there is no claimant 1 data' do
        data[:claimant_1] = { "title"=>"", "full_name"=>"", "street"=>"", "postcode"=>"", 'claimant_type' => 'individual'}
        claim = Claim.new(data)
        expect(claim).to_not be_valid
        expect(claim.claimant_1.errors.messages[:full_name]).to eq ["Enter claimant 1's full name"]
        expect(claim.claimant_1.errors.messages[:street]).to eq ["Enter claimant 1's full address"]
        expect(claim.claimant_1.errors.messages[:postcode]).to eq ["Enter claimant 1's postcode"]
      end

      it 'should be valid if there is claimant 1 data and no claimant 2 data' do
        data.delete(:claimant_2)
        claim = Claim.new(data)
        expect(claim).to be_valid
      end

      it 'should be valid if there is claimant one data and  claimant two data is all blank' do
        data[:claimant_2] = { "title"=>"", "full_name"=>"", "street"=>"", "postcode"=>""}
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

      context 'when no details are present for claimant 2' do
        before do
          data.delete(:claimant_2)
        end

        context 'javascript disabled' do
          it 'should not be valid' do
            expect(claim).to_not be_valid
            expect(claim.errors.full_messages).to eq [
              ["claim_claimant_2_title_error", "Enter claimant 2's title"],
              ["claim_claimant_2_full_name_error", "Enter claimant 2's full name"],
              ["claim_claimant_2_street_error", "Enter claimant 2's full address"],
              ["claim_claimant_2_postcode_error", "Enter claimant 2's postcode"]
            ]
          end
        end

        context 'javascript enabled' do
          it 'should not be valid' do
            data['javascript_enabled'] = 'true'
            expect(claim).to_not be_valid
            expect(claim.errors.full_messages).to eq [
              ["claim_claimant_2_title_error", "Enter claimant 2's title"],
              ["claim_claimant_2_full_name_error", "Enter claimant 2's full name"],
              ["claim_claimant_2_address_same_as_first_claimant_error", "You must specify whether the address is the same as the first claimant"]
            ]
          end
        end
      end

      context 'when the details for claimant 2 are blank' do
        before do
          data["claimant_2"].each { |k, v| data["claimant_2"][k] = '' }
        end
        context 'javascript disabled' do
          it 'should not be valid' do
            expect(claim).to_not be_valid
            expect(claim.errors.full_messages).to eq [
                ["claim_claimant_2_title_error", "Enter claimant 2's title"],
                ["claim_claimant_2_full_name_error", "Enter claimant 2's full name"],
                ["claim_claimant_2_street_error", "Enter claimant 2's full address"],
                ["claim_claimant_2_postcode_error", "Enter claimant 2's postcode"]
              ]
          end
        end
        context 'javascript enabled' do
          it 'should not be valid' do
            data['javascript_enabled'] = 'true'
            expect(claim).to_not be_valid
            expect(claim.errors.full_messages).to eq [
              ["claim_claimant_2_title_error", "Enter claimant 2's title"],
              ["claim_claimant_2_full_name_error", "Enter claimant 2's full name"],
              ["claim_claimant_2_address_same_as_first_claimant_error", "You must specify whether the address is the same as the first claimant"]
            ]
          end
        end
      end
    end

    context 'claimant_type_validation' do
      let(:data) {
        mydata = claim_post_data['claim']
        mydata['num_claimants'] = 1
        mydata.delete('claimant_2')
        mydata
      }

      it 'should be valid if claimant type is individual' do
        data['claimant_type'] = 'individual'
        data.delete('claimant_2')
        expect(Claim.new(data)).to be_valid
      end

      it 'should be valid if claimant type is organization' do
        data.delete('claimant_2')
        data['claimant_type'] = 'organization'
        data['claimant_1']['organization_name'] = 'AA Homes Ltd'
        expect(Claim.new(data)).to be_valid
      end

      it 'should not be valid if the claimant type is missing' do
        data.delete('claimant_type')
        claim = Claim.new(data)
        expect(claim).not_to be_valid
        expect(claim.errors[:base]).to eq [["claim_claimant_type_error", "Please select what kind of claimant you are"]]
      end

      it 'should not be valid if the claimant type is unknown' do
        data['claimant_type'] = 'XXXXXXXX'
        claim = Claim.new(data)
        expect(claim).not_to be_valid
        expect(claim.errors[:base]).to eq [["claim_claimant_type_error", "You must specify a valid kind of claimant"]]
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

    context 'method missing' do

      let(:claim)       { Claim.new }

      it 'should delegate to claimants.get(2) for :claimant_2' do
        claimants = double ClaimantCollection

        allow(claim).to receive(:claimants).and_return(claimants)
        expect(claimants).to receive(:[]).with(2)

        claim.claimant_2
      end

      it 'should delegate to claimants.put(2, params) for :claimant_2=(params)' do
        claimants = double ClaimantCollection

        allow(claim).to receive(:claimants).and_return(claimants)
        expect(claimants).to receive(:[]=).with(2, 'claimant_object')

        claim.claimant_2 = 'claimant_object'
      end

      it 'should raise method missing errors for unknown methods' do
        expect {
          claim.unknown_meth('abc', 3, :sym)
        }.to raise_error NoMethodError, /undefined method `unknown_meth' for/
      end

    end

    context 'invalid num claimants' do

      let(:data)  { claim_post_data['claim'] }
      let(:claim) { Claim.new(data) }

      it 'should not be valid if the num claimants is 0' do
        data[:num_claimants] = 0
        expect(claim).to_not be_valid
        expect(claim.errors.full_messages).to eq [["claim_num_claimants_error", "Please say how many claimants there are"]]
      end

      it 'should not be valid if the num claimants is blank' do
        data[:num_claimants] = ''
        expect(claim).to_not be_valid
        expect(claim.errors.full_messages).to eq [["claim_num_claimants_error", "Please say how many claimants there are"]]
      end

      it 'should not be valid if the num claimants is nil' do
        data.delete(:num_claimants)
        expect(claim).to_not be_valid
        expect(claim.errors.full_messages).to eq [["claim_num_claimants_error", "Please say how many claimants there are"]]
      end

      it 'should not be valid if greater than 4' do
        data[:num_claimants] = '5'
        expect(claim).to_not be_valid
        expect(claim.errors.full_messages).to eq [["claim_num_claimants_error", "If there are more than 4 claimants in this case, you’ll need to complete your accelerated possession claim on the N5b form"]]
      end
    end

    context 'collection of validation error messages' do
      it 'should transfer error messages from collections to base' do
        # given data with missing fields in the defendants collection
        data = claim_post_data['claim']
        data['defendant_1']['title'] = ''
        data['defendant_1']['full_name'] = ''
        data['defendant_2']['postcode'] = ''

        # when I instantiate a claim
        claim = Claim.new(data)

        # it should not be valid, and the defendants collection should have the expected error message(:s
        claim.valid?
        expect(claim.defendants).to_not be_valid
        expect(claim.defendants.errors['defendant_1_title']).to eq [ "Enter defendant 1's title",  ]
        expect(claim.defendants.errors['defendant_1_full_name']).to eq [ "Enter defendant 1's full name" ]
        expect(claim.defendants.errors['defendant_2_postcode']).to eq [ "Enter defendant 2's postcode" ]

        # and the messages should be transferred to claim.errors[:base]
        expect(claim.errors[:base]).to include(["claim_defendant_1_title_error", "Enter defendant 1's title"])
        expect(claim.errors[:base]).to include(["claim_defendant_1_full_name_error", "Enter defendant 1's full name"])
        expect(claim.errors[:base]).to include(["claim_defendant_2_postcode_error", "Enter defendant 2's postcode"])

      end
    end

    describe 'validation of number of defendants' do
      context 'with javascript enabled' do

        let(:javascript_enabled_params) do
          data = claim_post_data['claim']
          data['javascript_enabled'] = 'Yes'
          data
        end

        it 'should not validate 0 num defendants' do
          javascript_enabled_params['num_defendants'] = 0
          claim = Claim.new(javascript_enabled_params)
          expect(claim).not_to be_valid
          expect(claim.errors[:base]).to eq [["claim_num_defendants_error", "Please enter a valid number of defendants between 1 and 20"]]
        end

        it 'should not be valid if num_defendants > 20' do
          javascript_enabled_params['num_defendants'] = 21
          claim = Claim.new(javascript_enabled_params)
          expect(claim).not_to be_valid
          expect(claim.errors[:base]).to eq [["claim_num_defendants_error", "Please enter a valid number of defendants between 1 and 20"]]
        end

        it 'should be valid if num_defendants is 1' do
          javascript_enabled_params['num_defendants'] = 1
          javascript_enabled_params.delete('defendant_2')
          claim = Claim.new(javascript_enabled_params)
          expect(claim).to be_valid
          expect(claim.errors[:base]).to be_empty
        end

        it 'should be valid if num_defendants is 20' do
          javascript_enabled_params['num_defendants'] = 20
          (3 .. 20).each do |i|
            javascript_enabled_params["defendant_#{i}"] = javascript_enabled_params['defendant_2']
          end
          claim = Claim.new(javascript_enabled_params)
          expect(claim).to be_valid
          expect(claim.errors[:base]).to be_empty
        end
      end

      context('with javascript disabled') do
        let(:javascript_disabled_params) do
          claim_post_data['claim']
        end

        it 'should not validate 0 num defendants' do
          javascript_disabled_params['num_defendants'] = 0
          claim = Claim.new(javascript_disabled_params)
          expect(claim).not_to be_valid
          expect(claim.errors[:base]).to eq [["claim_num_defendants_error", "Please enter a valid number of defendants between 1 and 4"]]
        end

        it 'should not be valid if num_defendants > 4' do
          javascript_disabled_params['num_defendants'] = 5
          claim = Claim.new(javascript_disabled_params)
          expect(claim).not_to be_valid
          expect(claim.errors[:base]).to eq [["claim_num_defendants_error", "Please enter a valid number of defendants between 1 and 4"]]
        end

        it 'should be valid if num_defendants is 1' do
          javascript_disabled_params['num_defendants'] = 1
          javascript_disabled_params.delete('defendant_2')
          claim = Claim.new(javascript_disabled_params)
          expect(claim).to be_valid
          expect(claim.errors[:base]).to be_empty
        end

        it 'should be valid if num_defendants is 20' do
          javascript_disabled_params['num_defendants'] = 4
          (3 .. 4).each do |i|
            javascript_disabled_params["defendant_#{i}"] = javascript_disabled_params['defendant_2']
          end
          claim = Claim.new(javascript_disabled_params)
          expect(claim).to be_valid
          expect(claim.errors[:base]).to be_empty
        end

      end
    end

  end
end
