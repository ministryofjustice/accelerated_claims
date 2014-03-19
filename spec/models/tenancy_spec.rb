require 'spec_helper'

describe Tenancy do
  let(:tenancy) do
    Tenancy.new(start_date: Date.parse("2010-01-01"),
                latest_agreement_date: Date.parse("2010-01-01"),
                reissued_for_same_property: 'No',
                reissued_for_same_landlord_and_tenant: 'No',
                assured_shorthold_tenancy_notice_served_by: 'Mr Brown',
                assured_shorthold_tenancy_notice_served_date: Date.parse("2013-01-01"))
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

  describe "agreement_reissued_for_same_property" do
    it "when blank" do
      tenancy.reissued_for_same_property = ""
      tenancy.should_not be_valid
    end
  end

  describe 'when dates are blank' do
    before do
      @tenancy = Tenancy.new(
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

    it 'should not be valid' do
      @tenancy.should be_valid
    end

    it 'should have nil start date' do
      @tenancy.start_date.should be_nil
    end

    context 'and demoted_tenancy is true' do
      before do
        @tenancy.demoted_tenancy = true
      end
      it 'should be valid' do
        @tenancy.should be_valid
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
