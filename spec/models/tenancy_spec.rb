require 'spec_helper'

describe Tenancy do

  describe "#as_json" do
    describe "the base structure" do
      let(:desired_format) do
        {
          # tenancy_type derived
          "demoted_tenancy"=>"",
          "start_date_day"=>"",
          "start_date_month"=>"",
          "start_date_year"=>"",
          "latest_agreement_date_day"=>"",
          "latest_agreement_date_month"=>"",
          "latest_agreement_date_year"=>"",
          "assured_shorthold_tenancy_notice_served_date_day"=>"",
          "assured_shorthold_tenancy_notice_served_date_month"=>"",
          "assured_shorthold_tenancy_notice_served_date_year"=>"",
          "agreement_reissued_for_same_property"=> "",
          "agreement_reissued_for_same_landlord_and_tenant"=> "",
          "assured_shorthold_tenancy_notice_served_by" => "",
          "assured_shorthold_tenancy_notice_served_date_day" => "",
          "assured_shorthold_tenancy_notice_served_date_month" => "",
          "assured_shorthold_tenancy_notice_served_date_year" => "",
          "demotion_order_date_day" => "",
          "demotion_order_date_month" => "",
          "demotion_order_date_year" => "",
          "demotion_order_court" => ""
        }
      end

      describe "start_date in JSON" do
        # if original_assured_shorthold_tenancy_agreement_date present
        # then add it as start_date, otherwise
        # keep start_date as start_date
        let(:tenancy) do
          Tenancy.new("start_date(3i)"=>"10",
                      "start_date(2i)"=>"10",
                      "start_date(1i)"=>"2013",
                      "original_assured_shorthold_tenancy_agreement_date(3i)"=>"05",
                      "original_assured_shorthold_tenancy_agreement_date(2i)"=>"05",
                      "original_assured_shorthold_tenancy_agreement_date(1i)"=>"2010")
        end

        context "if original_assured_shorthold_tenancy_agreement_date not blank" do
          it "should assign it as start_date" do
            puts tenancy.as_json
            tenancy.as_json["start_date_day"].should eq "05"
            tenancy.as_json["start_date_month"].should eq "05"
            tenancy.as_json["start_date_year"].should eq "2010"
          end
        end
      end

      describe "demoted_tenancy in JSON" do
        context "when it's demoted" do
          let(:tenancy) { Tenancy.new(tenancy_type: "demoted") }

          subject { tenancy.as_json["demoted_tenancy"] }

          it { should eq "Yes" }
        end

        context "when it's assured" do
          let(:tenancy) { Tenancy.new(tenancy_type: "assured") }

          subject { tenancy.as_json["demoted_tenancy"] }

          it { should eq "No" }
        end
      end
    end
  end

  def value attribute, default, overrides
    overrides.has_key?(attribute) ? overrides[attribute] : default
  end

  def assured_tenancy overrides={}
    start_date_fields = form_date(:start_date, value(:start_date, Date.parse("2010-01-01"), overrides))
    latest_agreement_date_fields = form_date(:latest_agreement_date, value(:latest_agreement_date, Date.parse("2013-01-01"), overrides))

    Tenancy.new({
      tenancy_type: 'assured',
      assured_shorthold_tenancy_type: value(:assured_shorthold_tenancy_type, 'one', overrides),
      original_assured_shorthold_tenancy_agreement_date: value(:original_assured_shorthold_tenancy_agreement_date, nil, overrides),
      agreement_reissued_for_same_property: value(:agreement_reissued_for_same_property, nil, overrides),
      agreement_reissued_for_same_landlord_and_tenant: value(:agreement_reissued_for_same_landlord_and_tenant, nil, overrides)
    }.merge(start_date_fields)
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
      its(:start_date) { should == Date.parse("2010-01-01") }
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
      subject do
        assured_tenancy(
          assured_shorthold_tenancy_type: 'multiple',
          original_assured_shorthold_tenancy_agreement_date: Date.parse("2009-01-01"),
          start_date: start_date,
          agreement_reissued_for_same_property: 'No',
          agreement_reissued_for_same_landlord_and_tenant: 'Yes')
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
          subject.errors.full_messages.should == ["Start date must be blank if single tenancy agreement"]
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

  let(:start_date) { Date.parse("2010-01-01") }

  let(:tenancy) do
    data = {
      tenancy_type: 'assured',
      agreement_reissued_for_same_property: 'No',
      agreement_reissued_for_same_landlord_and_tenant: 'No',
      assured_shorthold_tenancy_notice_served_by: 'Mr Brown',
      assured_shorthold_tenancy_notice_served_date: Date.parse("2013-01-01")
    }
    data.merge! form_date(:start_date, start_date)
    data.merge! form_date(:latest_agreement_date, Date.parse("2010-01-01"))

    Tenancy.new(data)
  end

  let(:desired_format) do
    {
      "demoted_tenancy" => "No",
      "start_date_day" => "01",
      "start_date_month" => "01",
      "start_date_year" => "2010",
      "latest_agreement_date_day" => "01",
      "latest_agreement_date_month" => "01",
      "latest_agreement_date_year" => "2010",
      "agreement_reissued_for_same_property" => 'No',
      "agreement_reissued_for_same_landlord_and_tenant" => 'No',
      "assured_shorthold_tenancy_notice_served_by" => 'Mr Brown',
      "assured_shorthold_tenancy_notice_served_date_day" => "01",
      "assured_shorthold_tenancy_notice_served_date_month" => "01",
      "assured_shorthold_tenancy_notice_served_date_year" => "2013"
    }
  end

  describe "#as_json" do
    it "should generate the correct JSON" do
      assert_hash_is_correct tenancy.as_json, desired_format
    end
  end

  describe "the latest_agreement_date value" do
    it "can be blank" do
      tenancy.latest_agreement_date = nil
      json_mod = {
        'latest_agreement_date_day' => '',
        'latest_agreement_date_month' => '',
        'latest_agreement_date_year' => ''
      }
      assert_hash_is_correct tenancy.as_json, desired_format.merge(json_mod)
    end
  end

end
