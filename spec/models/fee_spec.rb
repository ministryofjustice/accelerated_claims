require 'spec_helper'

describe Fee do

  describe "when the court fee value is blank" do
    let(:fee) { Fee.new }

    it "shouldn't be valid" do
      fee.court_fee = ""
      fee.should_not be_valid
    end
  end

end
