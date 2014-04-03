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
          # TODO: rename this field in PDF
          # "agreement_reissued_for_same_property"=> nil,
          reissued_for_same_property => "",
          # TODO: rename this field in PDF
          # "agreement_reissued_for_same_landlord_and_tenant"=> nil,
          "reissued_for_same_landlord_and_tenant" => "",
          "assured_shorthold_tenancy_notice_served_by" => "",
          "assured_shorthold_tenancy_notice_served_date_day" => "",
          "assured_shorthold_tenancy_notice_served_date_month" => "",
          "assured_shorthold_tenancy_notice_served_date_year" => "",
          "original_assured_shorthold_tenancy_agreement_date_day" => "",
          "original_assured_shorthold_tenancy_agreement_date_month" => "",
          "original_assured_shorthold_tenancy_agreement_date_year" => "",
          "demotion_order_date_day" => "",
          "demotion_order_date_month" => "",
          "demotion_order_date_year" => "",
          "demotion_order_court" => ""
        }
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

    Tenancy.new({
      tenancy_type: 'assured',
      assured_shorthold_tenancy_type: value(:assured_shorthold_tenancy_type, 'one', overrides),
      start_date: value(:start_date, Date.parse("2010-01-01"), overrides),
      original_assured_shorthold_tenancy_agreement_date: value(:original_assured_shorthold_tenancy_agreement_date, nil, overrides),
      reissued_for_same_property: value(:reissued_for_same_property, nil, overrides),
      reissued_for_same_landlord_and_tenant: value(:reissued_for_same_landlord_and_tenant, nil, overrides)
    }.merge(start_date_fields)
    )
  end

  def demoted_tenancy overrides={}
    Tenancy.new(
      tenancy_type: 'demoted',
      demotion_order_date: Date.parse("2010-01-01"),
      demotion_order_court: "Brighton County Court",
      previous_tenancy_type: "assured"
    )
  end

  context "when 'demoted'" do
    subject do
      demoted_tenancy
    end

    it { should be_valid }
    its(:demoted_tenancy?) { should be_true }
    its(:assured_tenancy?) { should be_false }
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

    context 'and single tenancy' do
      subject{ assured_tenancy(assured_shorthold_tenancy_type: 'one') }
      it { should be_valid }
      its(:one_tenancy_agreement?) { should be_true }
      its(:multiple_tenancy_agreement?) { should be_false }

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
      end
    end

    shared_examples_for 'validates yes/no' do
      it "should only accept 'yes' & 'no'" do
        %w(yes no).each do |answer|
          subject.send("#{field}=", answer)
          subject.should be_valid
        end
      end

      it "should not accept answers other than 'yes' & 'no'" do
        %w(maybe idontknow).each do |answer|
          subject.send("#{field}=", answer)
          subject.should_not be_valid
        end
      end
    end

    context 'and multiple tenancy' do
      subject do
        assured_tenancy(
          assured_shorthold_tenancy_type: 'multiple',
          original_assured_shorthold_tenancy_agreement_date: Date.parse("2009-01-01"),
          reissued_for_same_property: 'no',
          reissued_for_same_landlord_and_tenant: 'yes')
      end
      it { should be_valid }
      its(:one_tenancy_agreement?) { should be_false }
      its(:multiple_tenancy_agreement?) { should be_true }

      describe "reissued_for_same_property" do
        let(:field) { :reissued_for_same_property }
        include_examples 'validates yes/no'
      end

      describe "reissued_for_same_landlord_and_tenant" do
        let(:field) { :reissued_for_same_landlord_and_tenant }
        include_examples 'validates yes/no'
      end

      context 'and start date is blank' do
        subject { assured_tenancy(start_date: nil,assured_shorthold_tenancy_type: 'multiple') }
        it { should_not be_valid }
      end

      context "when start_date is incorrect" do
        subject do
          Tenancy.new(tenancy_type: 'assured',
                      assured_shorthold_tenancy_type: 'multiple',
                      "start_date(3i)"=>"30",
                      "start_date(2i)"=>"2",
                      "start_date(1i)"=>"2013")
        end

        it { should_not be_valid }
      end

      context "when required fields blank" do
        subject { assured_tenancy(assured_shorthold_tenancy_type: 'multiple') }
        before { subject.valid? }

        it { subject.should_not be_valid }

        it "should have error messages for each missing field" do
          ["Original assured shorthold tenancy agreement date must be selected",
          "Reissued for same property must be selected",
          "Reissued for same landlord and tenant must be selected"].each do |msg|
            subject.errors.full_messages.should include msg
          end
        end
      end
    end
  end

  describe "demoted tenancy validations" do
    let(:tenancy) do
      Tenancy.new(tenancy_type: 'demoted',
                  start_date: Date.parse("2010-01-01"))

    end

    subject { tenancy }

    context "when it's a demoted tenancy" do
      it "should require demotion order date" do
        err = "Demotion order date must be selected"
        tenancy.valid?
        tenancy.errors.full_messages.should include err
      end

      it "should require county court" do
        err = "Demotion order court must be provided"
        tenancy.valid?
        tenancy.errors.full_messages.should include err
      end

      it "should require previous tenancy agreement type" do
        err = "Previous tenancy type must be selected"
        tenancy.valid?
        tenancy.errors.full_messages.should include err
      end

      describe "previous tenancy agreement validation" do
        context "where demotion order date and demotion order court are valid" do
          let(:tenancy) do
            Tenancy.new(tenancy_type: 'demoted',
                        demotion_order_date: Date.parse("2010-01-01"),
                        demotion_order_court: "Brighton County Court")
          end

          it "should only accept 'assured' & 'secure'" do
            ['assured', 'secure'].each do |answer|
              tenancy.previous_tenancy_type = answer
              tenancy.valid?
              tenancy.should be_valid
            end
          end
        end
      end
    end
  end

  let(:start_date) { Date.parse("2010-01-01") }

  let(:tenancy) do
    data = {
      tenancy_type: 'assured',
      reissued_for_same_property: 'No',
      reissued_for_same_landlord_and_tenant: 'No',
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

  describe "when given all valid values" do
    it "should be valid" do
      pending
      tenancy.should be_valid
    end
  end

  describe "#only_start_date_present?" do
    context "when only start date is set everything else isn't" do
      let(:tenancy) { Tenancy.new(start_date: Date.parse("2010-01-01")) }

      it "should return true" do
        expect(tenancy.only_start_date_present?).to be_true
      end
    end

    context "when only start date and another attribute is set" do
      let(:tenancy) do
        Tenancy.new(start_date: Date.parse("2010-01-01"),
                    latest_agreement_date: Date.parse("2011-01-01"))
      end

      it "should return false" do
        expect(tenancy.only_start_date_present?).to be_false
      end
    end

  end

  describe "agreement_reissued_for_same_property" do
    it "when blank" do
      tenancy.reissued_for_same_property = ""
      tenancy.should_not be_valid
    end
  end

  describe 'when dates for assured tenancy are blank' do
    before do
      @tenancy = Tenancy.new(tenancy_type: 'demoted',
                             reissued_for_same_property: 'No',
                             reissued_for_same_landlord_and_tenant: 'No',
                             start_date: "",
                             latest_agreement_date: "",
                             demotion_order_date: Date.parse("2010-01-01"),
                             demotion_order_court: "Brighton County Court",
                             previous_tenancy_type: "assured")
    end

    it 'should be valid' do
      @tenancy.should be_valid
    end

    it 'should have a blank start date' do
      @tenancy.start_date.should be_blank
    end

    context "and it's not a demoted tenancy" do
      before { @tenancy.tenancy_type = 'assured' }

      it 'should not be valid' do
        @tenancy.should_not be_valid
      end
    end
  end

  describe 'when latest_agreement_date is blank' do
    before do
      @tenancy = Tenancy.new(tenancy_type: 'assured',
                             assured_shorthold_tenancy_type: 'one',
                             reissued_for_same_property: '',
                             reissued_for_same_landlord_and_tenant: '',
                             "start_date(3i)"=>"2",
                             "start_date(2i)"=>"2",
                             "start_date(1i)"=>"2013",
                             "latest_agreement_date(3i)"=>"",
                             "latest_agreement_date(2i)"=>"",
                             "latest_agreement_date(1i)"=>"")
    end

    it 'should be valid' do
      @tenancy.should be_valid
    end

    it 'should have nil latest_agreement_date' do
      @tenancy.latest_agreement_date.should be_nil
    end

    it 'should have populated start_date' do
      @tenancy.start_date.should == Date.parse("2013-02-02")
    end
  end

  describe "#as_json" do
    it "should generate the correct JSON" do
      tenancy.as_json.should eq desired_format
    end
  end

  describe 'start date is an invalid date' do
    let(:start_date) { date = OpenStruct.new; date.year=2010; date.month=2; date.day=31; date }

    it 'should be invalid' do
      tenancy.should_not be_valid
    end

    it 'should have invalid date error' do
      pending
      tenancy.valid?
      tenancy.errors.full_messages.should == ["Start date is invalid date"]
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
      expect(tenancy.as_json).to eql desired_format.merge(json_mod)
    end
  end


end
