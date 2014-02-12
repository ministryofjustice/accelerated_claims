require 'spec_helper'

describe Order do
  let(:order) { Order.new(possession: true, cost: true) }

  describe "when given all valid values" do
    it "should be valid" do
      order.should be_valid
    end
  end

  describe "possession" do
    it "should not be blank" do
      order.possession = ""
      order.should_not be_valid
    end
  end

  describe "cost" do
    it "should not be blank" do
      order.cost = ""
      order.should_not be_valid
    end
  end

  describe "#as_json" do
    let(:desired_format) do
      {
        "possession" => true,
        "cost" => true
      }
    end
  end

end
