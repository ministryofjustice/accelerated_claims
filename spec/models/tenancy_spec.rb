require 'spec_helper'

describe Tenancy do
  describe "tenancy_type" do
    context "when 'assured' value is given" do

      subject do
        Tenancy.new(tenancy_type: 'assured',
                    assured_shorthold_tenancy_type: 'one',
                    start_date: Date.parse("2010-01-01"))
      end

      it { should be_valid }

      context "but no start date is provided" do
        subject { Tenancy.new(tenancy_type: 'assured') }

        it { should_not be_valid }
      end
    end

    context "when 'demoted' values is given" do
      subject do
        Tenancy.new(tenancy_type: 'demoted',
                    demotion_order_date: Date.parse("2010-01-01"),
                    demotion_order_court: "Brighton County Court",
                    previous_tenancy_type: "assured")
      end

      it { should be_valid }
    end

    context "when it isn't 'demoted' or 'assured' value" do
      ['Blah', ''].each do |answer|
        subject { Tenancy.new(tenancy_type: answer) }
        it { should_not be_valid }
      end

      describe "when no value is provided" do
        let(:tenancy) { Tenancy.new(tenancy_type: "") }
        before { tenancy.valid? }

        it "should provide an error message" do
          tenancy.errors.full_messages.should include "Tenancy type must be selected"
        end
      end
    end
  end

  describe "#demoted_tenancy?" do
    let(:tenancy) do
      Tenancy.new(tenancy_type: 'demoted', start_date: Date.parse("2010-01-01"))
    end

    subject { tenancy }

    context "when demoted tenancy is set" do
      it "should return true" do
        expect(tenancy.demoted_tenancy?).to be_true
      end
    end

    context "it isn't a demoted tenancy" do
      before { tenancy.tenancy_type = 'assured' }

      it "should return false" do
        expect(tenancy.demoted_tenancy?).to be_false
      end
    end
  end

  describe "#assured_tenancy?" do
    let(:tenancy) do
      Tenancy.new(tenancy_type: 'assured')
    end

    subject { tenancy }

    context "when assured tenancy is set" do
      it "should return true" do
        expect(tenancy.assured_tenancy?).to be_true
      end
    end

    context "it isn't a assured tenancy" do
      before { tenancy.tenancy_type = 'demoted' }

      it "should return false" do
        expect(tenancy.assured_tenancy?).to be_false
      end
    end
  end

  describe "assured tenancy validations" do
    context "when the tenancy is assured" do
      let(:tenancy) do
        Tenancy.new(tenancy_type: 'assured',
                    start_date: Date.parse("2010-01-01"))
      end
      before { tenancy.valid? }

      it "should require assured tenancy type" do
        tenancy.errors.full_messages.should include "Assured shorthold tenancy type must be selected"
      end

      it "should display error messages for missing attributes" do
        errs = ["Assured shorthold tenancy type must be selected"]
        tenancy.errors.full_messages.should eq errs
      end

      describe "assured_shorthold_tenancy_type" do
        context "when there is only one tenancy" do
          subject do
            Tenancy.new(tenancy_type: 'assured',
                        assured_shorthold_tenancy_type: 'one',
                        start_date: Date.parse("2010-01-01"))
          end

          it { should be_valid }
        end

        context "when there are multiple tenancies" do
          subject do
            Tenancy.new(tenancy_type: 'assured',
                        assured_shorthold_tenancy_type: 'multiple',
                        start_date: Date.parse("2010-01-01"),
                        original_assured_shorthold_tenancy_agreement_date: Date.parse("2009-01-01"),
                        reissued_for_same_property: 'no')
          end

          it { should be_valid }
        end

        context "when given invalid values" do
          ['1', ''].each do |answer|
            subject do
              Tenancy.new(tenancy_type: 'assured',
                          assured_shorthold_tenancy_type: answer,
                          start_date: Date.parse("2010-01-01"))
            end

            it { should_not be_valid }
          end
        end
      end

      describe "#one_tenancy_agreement?" do
        let(:tenancy) do
          Tenancy.new(tenancy_type: 'assured',
                      assured_shorthold_tenancy_type: 'one',
                      start_date: Date.parse("2010-01-01"))
        end

        subject { tenancy.one_tenancy_agreement? }

        it { should be true }

      end

      describe "#multiple_tenancy_agreements?" do
        let(:tenancy) do
          Tenancy.new(tenancy_type: 'assured',
                      assured_shorthold_tenancy_type: 'multiple',
                      start_date: Date.parse("2010-01-01"))
        end

        subject { tenancy.multiple_tenancy_agreements? }

        it { should be true }

      end


      context "when tenancy has only one tenancy agreement" do
        describe "start_date validation" do
          let(:tenancy) do
            data = {
              tenancy_type: 'assured',
              assured_shorthold_tenancy_type: 'one'
            }
            data.merge! form_date(:start_date, Date.parse("2010-01-01"))

            Tenancy.new(data)
          end

          subject { tenancy }

          it { should be_valid }

          context "when start_date is missing" do
            before do
              tenancy.start_date = ""
              tenancy.valid?
            end

            it { should_not be_valid }
          end

          context "when start_date is incorrect" do
            let(:tenancy) do
              Tenancy.new(tenancy_type: 'assured',
                          assured_shorthold_tenancy_type: 'one',
                          "start_date(3i)"=>"30",
                          "start_date(2i)"=>"2",
                          "start_date(1i)"=>"2013")
            end

            it "should not be valid" do
              tenancy.should_not be_valid
            end
          end
        end
      end

      context "when tenancy has multiple tenancy agreements" do
        let(:tenancy) do
          Tenancy.new(tenancy_type: 'assured',
                      assured_shorthold_tenancy_type: 'multiple',
                      original_assured_shorthold_tenancy_agreement_date: Date.parse("2012-01-30"),
                      reissued_for_same_property: 'yes',
                      "start_date(3i)"=>"30",
                      "start_date(2i)"=>"1",
                      "start_date(1i)"=>"2013")
        end

        describe "start_date validation" do
          context "when start_date is missing" do


            subject { tenancy }

            it { should be_valid }
          end

          context "when start_date is present" do
            it "should not be valid"
          end
        end

        describe "original_assured_shorthold_tenancy_agreement_date" do
          before do
            tenancy.original_assured_shorthold_tenancy_agreement_date = ''
            tenancy.valid?
          end

          it { tenancy.should_not be_valid }

          it "should only have 1 error" do
            tenancy.errors.count.should eq 1
          end

          it "should have an error message about it" do
            err = ["Original assured shorthold tenancy agreement date must be selected"]
            tenancy.errors.full_messages.should eq err
          end
        end

        describe "reissued_for_same_property" do
          before do
            tenancy.reissued_for_same_property = ''
            tenancy.valid?
          end

          it { tenancy.should_not be_valid }

          it { tenancy.errors.count.should eq 1 }

          it "should have an error message about it" do
            err = ["Reissued for same property must be selected"]
            tenancy.errors.full_messages.should eq err
          end

          it "should only accept 'yes' & 'no'" do
            %w(yes no).each do |answer|
              tenancy.reissued_for_same_property = answer
              tenancy.valid?
              tenancy.should be_valid
            end
          end

          it "should not accept answers other than 'yes' & 'no'" do
            %w(maybe idontknow).each do |answer|
              tenancy.reissued_for_same_property = answer
              tenancy.valid?
              tenancy.should_not be_valid
            end
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
      "tenancy_type" => "assured",
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
