require 'spec_helper'

describe Deposit do
  let(:deposit) { Deposit.new(received: true, ref_number: 123, as_property: false) }

  describe "when given all valid values" do
    it "should be valid" do
      deposit.should be_valid
    end
  end

  describe "when money deposit value is blank" do
    it "shouldn't be valid" do
      deposit.received = ""
      deposit.should_not be_valid
    end
  end

  describe "when deposit's property is blank" do
    it "shouldn't be valid" do
      deposit.as_property = ""
      deposit.should_not be_valid
    end
  end
end
