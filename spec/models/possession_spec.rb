require 'spec_helper'

describe Possession do
  let(:defendant) { Possession.new(hearing: 'Yes') }

  describe "when a hearing is provided" do
    it "should be valid" do
      defendant.should be_valid
    end
  end

  describe "when a hearing is not provided" do
    it "should be valid" do
      defendant.hearing = 'no'
      defendant.should be_valid
    end
  end

  describe "when the hearing is blank" do
    it "shouldn't be valid" do
      defendant.hearing = ""
      defendant.should_not be_valid
    end
  end

  describe "#as_json" do
    let(:desired_format) { { "hearing" => 'Yes' } }

    it "should produce formatted output" do
      expect(defendant.as_json).to eq desired_format
    end
  end
end
