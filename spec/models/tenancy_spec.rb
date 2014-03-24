require 'spec_helper'

describe Tenancy do

  let(:start_date) { Date.parse("2010-01-01") }

  let(:tenancy) do
    data = {
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

  describe 'when dates are blank' do
    before do
      @tenancy = Tenancy.new(
        demoted_tenancy: true,
        reissued_for_same_property: 'No',
        reissued_for_same_landlord_and_tenant: 'No',
       "start_date(3i)"=>"",
       "start_date(2i)"=>"",
       "start_date(1i)"=>"",
       "latest_agreement_date(3i)"=>"",
       "latest_agreement_date(2i)"=>"",
       "latest_agreement_date(1i)"=>""
        )
    end

    it 'should be valid' do
      @tenancy.should be_valid
    end

    it 'should have nil start date' do
      @tenancy.start_date.should be_nil
    end

    context 'and demoted_tenancy is false' do
      before do
        @tenancy.demoted_tenancy = false
      end
      it 'should not be valid' do
        @tenancy.should_not be_valid
      end
    end
  end

  describe 'when latest_agreement_date is blank' do
    before do
      @tenancy = Tenancy.new(
        reissued_for_same_property: '',
        reissued_for_same_landlord_and_tenant: '',
       "start_date(3i)"=>"2",
       "start_date(2i)"=>"2",
       "start_date(1i)"=>"2013",
       "latest_agreement_date(3i)"=>"",
       "latest_agreement_date(2i)"=>"",
       "latest_agreement_date(1i)"=>""
        )
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
