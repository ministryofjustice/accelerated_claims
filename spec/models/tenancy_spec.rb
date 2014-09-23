# -*- coding: utf-8 -*-
describe Tenancy, :type => :model do

  include TenancyHelper

  shared_examples_for 'assured_shorthold_tenancy_type unset' do
    it { is_expected.not_to be_valid }
    its(:one_tenancy_agreement?) { should be false }
    its(:multiple_tenancy_agreements?) { should be false }

    it "should have error message" do
      subject.valid?
      expect(subject.errors.full_messages).to include 'Assured shorthold tenancy type leave blank as you specified tenancy is demoted'
    end

    it "should set assured_shorthold_tenancy_type nil" do
      subject.valid?
      expect(subject.assured_shorthold_tenancy_type).to be_nil
    end
  end

  context "when 'demoted'" do
    subject { demoted_tenancy }

    it { is_expected.to be_valid }
    its(:demoted_tenancy?) { should be true }
    its(:assured_tenancy?) { should be false }

    context 'when assured_shorthold_tenancy_type "one"' do
      before { subject.assured_shorthold_tenancy_type = 'one' }
      include_examples 'assured_shorthold_tenancy_type unset'
    end

    context 'when assured_shorthold_tenancy_type "multiple"' do
      before { subject.assured_shorthold_tenancy_type = 'multiple' }
      include_examples 'assured_shorthold_tenancy_type unset'
    end

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
      it { is_expected.not_to be_valid }

      it "should have error messages for each missing field" do
        expect(subject).not_to be_valid
        expect(subject.errors[:demotion_order_date]).to eq ['Enter the date of the tenancy demotion order']
        expect(subject.errors[:previous_tenancy_type]).to eq ['Select the type of tenancy agreement before it was demoted']
        expect(subject.errors[:demotion_order_court]).to eq ['Enter the name of the court that demoted the tenancy']
      end
    end

    it "should only accept 'assured' & 'secure' for previous_tenancy_type" do
      ['assured', 'secure'].each do |answer|
        subject.previous_tenancy_type = answer
        subject.valid?
        expect(subject).to be_valid
      end
    end
  end

  context "when 'demoted' and non-relevant fields are not blank" do
    subject { assured_tenancy(demoted_tenancy.attributes) }

    it { is_expected.not_to be_valid }

    it "should have error messages for each non-relevant field" do
      subject.valid?
      ['Assured shorthold tenancy type leave blank as you specified tenancy is demoted',
       'Assured shorthold tenancy type leave blank as you specified tenancy is demoted',
       'Start date leave blank as you specified tenancy is demoted'].each do |msg|
        expect(subject.errors.full_messages).to include msg
      end
    end
  end

  context "when not 'demoted' or 'assured'" do
    ['Blah', ''].each do |answer|
      subject { Tenancy.new(tenancy_type: answer) }
      it { is_expected.not_to be_valid }
      its(:demoted_tenancy?) { should be false }
      its(:assured_tenancy?) { should be false }
    end

    describe "when no value is provided" do
      let(:tenancy) { Tenancy.new(tenancy_type: "") }
      before { tenancy.valid? }

      it "should provide an error message" do
        expect(tenancy.errors[:tenancy_type]).to eq [ "You must say what kind of tenancy agreement you have" ]
      end

      it 'should not have applicable statement errors' do
        expect(tenancy.errors[:confirmed_second_rules_period_applicable_statements]).to eq []
        expect(tenancy.errors[:confirmed_first_rules_period_applicable_statements]).to eq []
      end
    end
  end

  shared_examples_for 'previous_tenancy_type unset' do
    it { is_expected.not_to be_valid }

    it "should have error message" do
      subject.valid?
      expect(subject.errors.full_messages).to include 'Previous tenancy type leave blank as you specified tenancy is not demoted'
    end

    it "should set previous_tenancy_type nil" do
      subject.valid?
      expect(subject.previous_tenancy_type).to be_nil
    end
  end

  context "when 'assured'" do
    context 'one tenancy agreement' do
      describe 'as_json' do
        subject { assured_tenancy.as_json }
        its(['demoted_tenancy']) { should == 'No'}
        its(['start_date_day']) { should == '05' }
        its(['start_date_month']) { should == '01' }
        its(['start_date_year']) { should == '2010' }
        its(['latest_agreement_date_day']) { should == '' }
        its(['latest_agreement_date_month']) { should == '' }
        its(['latest_agreement_date_year']) { should == '' }
        its(['assured_shorthold_tenancy_type']) { should == 'one' }
      end
    end
  end

  context "when 'assured'" do
    subject { assured_tenancy }

    it { is_expected.to be_valid }
    its(:demoted_tenancy?) { should be false }
    its(:assured_tenancy?) { should be true }
  end

  context "when 'assured'" do
    subject { assured_tenancy }

    context 'multiple tenancy agreements' do
      describe 'as_json' do
        subject {
          assured_tenancy({'assured_shorthold_tenancy_type' => 'multiple'}).as_json
        }

        its(['demoted_tenancy']) { should == 'No'}
        its(['start_date_day']) { should == '05' }
        its(['start_date_month']) { should == '01' }
        its(['start_date_year']) { should == '2010' }
        its(['latest_agreement_date_day']) { should == '' }
        its(['latest_agreement_date_month']) { should == '' }
        its(['latest_agreement_date_year']) { should == '' }
        its(['assured_shorthold_tenancy_type']) { should == 'multiple' }
      end
    end

    context 'when previous_tenancy_type "secure"' do
      before { subject.previous_tenancy_type = 'secure' }
      include_examples 'previous_tenancy_type unset'
    end

    context 'when previous_tenancy_type "assured"' do
      before { subject.previous_tenancy_type = 'assured' }
      include_examples 'previous_tenancy_type unset'
    end

    context "and start date is blank" do
      subject { assured_tenancy(start_date: nil) }
      it { is_expected.not_to be_valid }
    end

    context 'and assured_shorthold_tenancy_type is blank' do
      subject { assured_tenancy(assured_shorthold_tenancy_type: nil) }

      it "should require assured tenancy type" do
        subject.valid?
        expect(subject.errors[:assured_shorthold_tenancy_type]).to eq [ "You must say how many tenancy agreements you’ve had" ]
      end
    end

    context 'and single tenancy agreement' do
      subject{ assured_tenancy(assured_shorthold_tenancy_type: 'one') }
      it { is_expected.to be_valid }

      its(:one_tenancy_agreement?) { should be true }
      its(:multiple_tenancy_agreements?) { should be false }
      its(:start_date) { should == Date.parse("2010-01-05") }
      its(:latest_agreement_date) { should be_nil }
      its(:only_start_date_present?) { should be true }

      context 'and start date is blank' do
        subject { assured_tenancy(start_date: nil) }
        it { is_expected.not_to be_valid }
      end

      context "when start_date is incorrect" do
        subject do
          Tenancy.new(tenancy_type: 'assured',
                      assured_shorthold_tenancy_type: 'one',
                      "start_date(3i)"=>"30",
                      "start_date(2i)"=>"2",
                      "start_date(1i)"=>"2013")
        end

        it { is_expected.not_to be_valid }

        it 'should have invalid date error' do
          subject.valid?
          expect(subject.errors.full_messages).to eq(["Start date is invalid date"])
        end
      end

      context 'when start_date before 15 January 1989' do
        subject{ assured_tenancy(assured_shorthold_tenancy_type: 'one',
          start_date: (Tenancy::APPLICABLE_FROM_DATE - 1)) }

        it { should_not be_valid }
      end

    end

    shared_examples_for 'validates yes/no' do
      it "should only accept 'Yes' & 'No'" do
        %w(Yes No).each do |answer|
          subject.send("#{field}=", answer)
          expect(subject).to be_valid
        end
      end

      it "should not accept answers other than 'Yes' & 'No'" do
        %w(maybe idontknow).each do |answer|
          subject.send("#{field}=", answer)
          expect(subject).not_to be_valid
        end
      end
    end

    context 'and multiple tenancy agreements' do
      let(:start_date) { nil }
      let(:multiple_tenancy) {
        assured_tenancy(
          assured_shorthold_tenancy_type: 'multiple',
          assured_shorthold_tenancy_notice_served_date: Date.parse("2010-10-01"),
          assured_shorthold_tenancy_notice_served_by: 'Mr Brown',
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

      it { is_expected.to be_valid }
      its(:one_tenancy_agreement?) { should be false }
      its(:multiple_tenancy_agreements?) { should be true }
      its(:only_start_date_present?) { should be false }

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
        it { is_expected.not_to be_valid }
        it 'should have error message' do
          subject.valid?
          expect(subject.errors.full_messages).to eq(["Start date If you have more than one tenancy agreement, please answer 'not applicable' to this question."])
        end
      end

      context "when required fields blank" do
        subject { assured_tenancy(assured_shorthold_tenancy_type: 'multiple') }

        it { expect(subject).not_to be_valid }

        it "should have error messages for each missing field" do
          subject.valid?
          [
          "Original assured shorthold tenancy agreement date You must say when the original tenancy agreement started",
          "Latest agreement date You must say when the most recent tenancy agreement started",
          "Agreement reissued for same property You must say whether the tenancy agreement is for the same property",
          "Agreement reissued for same landlord and tenant You must say whether the tenancy agreement is between the same landlord and tenant",
          "Start date If you have more than one tenancy agreement, please answer 'not applicable' to this question."].each do |msg|
            expect(subject.errors.full_messages).to include msg
          end
        end

        context 'but start date present' do
          its(:only_start_date_present?) { should be true }
        end
      end

    end
  end

end
