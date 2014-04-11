describe Tenancy do

  def value attribute, default, overrides
    overrides.has_key?(attribute) ? overrides[attribute] : default
  end

  def assured_tenancy overrides={}
    date_fields = {}.merge (
      form_date(:start_date, value(:start_date, Date.parse("2010-01-05"), overrides))
    ).merge (
      form_date(:assured_shorthold_tenancy_notice_served_date, value(:assured_shorthold_tenancy_notice_served_date, nil, overrides))
    ).merge (
      form_date(:original_assured_shorthold_tenancy_agreement_date, value(:original_assured_shorthold_tenancy_agreement_date, nil, overrides))
    ).merge (
      form_date(:latest_agreement_date, value(:latest_agreement_date, nil, overrides))
    )

    Tenancy.new({
      tenancy_type: 'assured',
      assured_shorthold_tenancy_type: value(:assured_shorthold_tenancy_type, 'one', overrides),
      agreement_reissued_for_same_property: value(:agreement_reissued_for_same_property, nil, overrides),
      agreement_reissued_for_same_landlord_and_tenant: value(:agreement_reissued_for_same_landlord_and_tenant, nil, overrides),
      applicable_statements_1: 'Yes',
      applicable_statements_2: 'Yes',
      applicable_statements_3: 'Yes',
      applicable_statements_4: 'No',
      applicable_statements_5: 'No',
      applicable_statements_6: 'No'
    }.merge(date_fields)
    )
  end

  def demoted_tenancy overrides={}
    Tenancy.new(
      tenancy_type: 'demoted',
      demotion_order_date: value(:demotion_order_date, Date.parse("2010-01-01"), overrides),
      demotion_order_court: value(:demotion_order_court, "Brighton County Court", overrides),
      previous_tenancy_type: value(:previous_tenancy_type, "assured", overrides)
    )
  end

  context "when 'demoted'" do
    subject { demoted_tenancy }

    it { should be_valid }
    its(:demoted_tenancy?) { should be_true }
    its(:assured_tenancy?) { should be_false }

    describe 'as_json' do
      subject { demoted_tenancy.as_json }
      its(['demoted_tenancy']) { should == 'Yes'}
      its(['demotion_order_date_day']) { should eq '01' }
      its(['demotion_order_date_month']) { should eq '01' }
      its(['demotion_order_date_year']) { should eq '2010' }
      its(['demotion_order_court']) { should eq 'Brighton' }
      its(['previous_tenancy_type']) { should == 'assured' }
    end

    context 'and required fields are blank' do
      subject { demoted_tenancy(demotion_order_date: nil, demotion_order_court: nil, previous_tenancy_type: nil) }
      it { should_not be_valid }

      it "should have error messages for each missing field" do
        subject.valid?
        ["Demotion order date must be selected",
        "Previous tenancy type must be selected",
        "Demotion order court must be provided"].each do |msg|
          subject.errors.full_messages.should include msg
        end
      end
    end

    it "should only accept 'assured' & 'secure' for previous_tenancy_type" do
      ['assured', 'secure'].each do |answer|
        subject.previous_tenancy_type = answer
        subject.valid?
        subject.should be_valid
      end
    end
  end

  context "when not 'demoted' or 'assured'" do
    ['Blah', ''].each do |answer|
      subject { Tenancy.new(tenancy_type: answer) }
      it { should_not be_valid }
      its(:demoted_tenancy?) { should be_false }
      its(:assured_tenancy?) { should be_false }
    end

    describe "when no value is provided" do
      let(:tenancy) { Tenancy.new(tenancy_type: "") }
      before { tenancy.valid? }

      it "should provide an error message" do
        tenancy.errors.full_messages.should include "Tenancy type must be selected"
      end
    end
  end

  context "when 'assured'" do
    subject { assured_tenancy }

    it { should be_valid }
    its(:demoted_tenancy?) { should be_false }
    its(:assured_tenancy?) { should be_true }

    describe 'as_json' do
      subject { assured_tenancy.as_json }
      its(['demoted_tenancy']) { should == 'No'}
      its(['start_date_day']) { should == '05' }
      its(['start_date_month']) { should == '01' }
      its(['start_date_year']) { should == '2010' }
      its(['latest_agreement_date_day']) { should == '' }
      its(['latest_agreement_date_month']) { should == '' }
      its(['latest_agreement_date_year']) { should == '' }
    end

    context "and start date is blank" do
      subject { assured_tenancy(start_date: nil) }
      it { should_not be_valid }
    end

    context 'and assured_shorthold_tenancy_type is blank' do
      subject { assured_tenancy(assured_shorthold_tenancy_type: nil) }

      it "should require assured tenancy type" do
        subject.valid?
        subject.errors.full_messages.should include "Assured shorthold tenancy type must be selected"
      end
    end

    context 'and single tenancy agreement' do
      subject{ assured_tenancy(assured_shorthold_tenancy_type: 'one') }
      it { should be_valid }

      its(:one_tenancy_agreement?) { should be_true }
      its(:multiple_tenancy_agreements?) { should be_false }
      its(:start_date) { should == Date.parse("2010-01-05") }
      its(:latest_agreement_date) { should be_nil }
      its(:only_start_date_present?) { should be_true }

      context 'and start date is blank' do
        subject { assured_tenancy(start_date: nil) }
        it { should_not be_valid }
      end

      context "when start_date is incorrect" do
        subject do
          Tenancy.new(tenancy_type: 'assured',
                      assured_shorthold_tenancy_type: 'one',
                      "start_date(3i)"=>"30",
                      "start_date(2i)"=>"2",
                      "start_date(1i)"=>"2013")
        end

        it { should_not be_valid }

        it 'should have invalid date error' do
          subject.valid?
          subject.errors.full_messages.should == ["Start date is invalid date"]
        end
      end
    end

    shared_examples_for 'validates yes/no' do
      it "should only accept 'Yes' & 'No'" do
        %w(Yes No).each do |answer|
          subject.send("#{field}=", answer)
          subject.should be_valid
        end
      end

      it "should not accept answers other than 'Yes' & 'No'" do
        %w(maybe idontknow).each do |answer|
          subject.send("#{field}=", answer)
          subject.should_not be_valid
        end
      end
    end

    context 'and multiple tenancy agreements' do
      let(:start_date) { nil }
      let(:multiple_tenancy) {
        assured_tenancy(
          assured_shorthold_tenancy_type: 'multiple',
          assured_shorthold_tenancy_notice_served_date: Date.parse("2010-10-01"),
          original_assured_shorthold_tenancy_agreement_date: Date.parse("2009-02-01"),
          latest_agreement_date: Date.parse("2012-01-02"),
          start_date: start_date,
          agreement_reissued_for_same_property: 'No',
          agreement_reissued_for_same_landlord_and_tenant: 'Yes')
      }
      subject { multiple_tenancy }

      describe 'as_json' do
        subject { multiple_tenancy.as_json }
        its(['agreement_reissued_for_same_landlord_and_tenant']) { should == 'Yes' }
        its(['agreement_reissued_for_same_property']) { should == 'No' }
        its(['assured_shorthold_tenancy_notice_served_date_day']) { should eq '01' }
        its(['assured_shorthold_tenancy_notice_served_date_month']) { should eq '10' }
        its(['assured_shorthold_tenancy_notice_served_date_year']) { should eq '2010' }
        its(['original_assured_shorthold_tenancy_agreement_date_day']) { should eq '01' }
        its(['original_assured_shorthold_tenancy_agreement_date_month']) { should eq '02' }
        its(['original_assured_shorthold_tenancy_agreement_date_year']) { should eq '2009' }
      end

      it { should be_valid }
      its(:one_tenancy_agreement?) { should be_false }
      its(:multiple_tenancy_agreements?) { should be_true }
      its(:only_start_date_present?) { should be_false }

      describe "agreement_reissued_for_same_property" do
        let(:field) { :agreement_reissued_for_same_property }
        include_examples 'validates yes/no'
      end

      describe "agreement_reissued_for_same_landlord_and_tenant" do
        let(:field) { :agreement_reissued_for_same_landlord_and_tenant }
        include_examples 'validates yes/no'
      end

      context 'and start date is present' do
        let(:start_date) { Date.parse("2009-01-01") }
        it { should_not be_valid }
        it 'should have error message' do
          subject.valid?
          subject.errors.full_messages.should == ["Start date must be blank if more than one tenancy agreement"]
        end
      end

      context "when required fields blank" do
        subject { assured_tenancy(assured_shorthold_tenancy_type: 'multiple') }

        it { subject.should_not be_valid }

        it "should have error messages for each missing field" do
          subject.valid?
          ["Original assured shorthold tenancy agreement date must be selected",
          "Agreement reissued for same property must be selected",
          "Agreement reissued for same landlord and tenant must be selected"].each do |msg|
            subject.errors.full_messages.should include msg
          end
        end

        context 'but start date present' do
          its(:only_start_date_present?) { should be_true }
        end
      end

    end
  end

end
