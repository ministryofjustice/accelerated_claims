require 'spec_helper'

describe Notice do
  let(:notice) do
    Notice.new(served_by: "Jim Bob",
               date_served: "1,1,2014",
               expiry_date: "31,3,2014")
  end

  describe "when given all valid values" do
    it "should be valid" do
      notice.should be_valid
    end
  end

  describe "served_by" do
    it "should be required" do
      notice.served_by = ""
      notice.should_not be_valid
    end

    it "should be under 40 characters" do
      notice.served_by = "x" * 41
      notice.should_not be_valid
    end
  end

  describe "date served" do
    it "should be provided" do
      notice.date_served = ""
      notice.should_not be_valid
    end
  end

  describe "expiry date" do
    it "should be provided" do
      notice.expiry_date = ""
      notice.should_not be_valid
    end
  end

end
