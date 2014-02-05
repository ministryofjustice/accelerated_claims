require 'spec_helper'

describe Defendant do
  let(:defendant) { Defendant.new(hearing: true) }

  describe "when a hearing is provided" do
    it "should be valid" do
      defendant.should be_valid
    end
  end

  describe "when a hearing is not provided" do
    it "should be valid" do
      defendant.hearing = false
      defendant.should be_valid
    end
  end

  describe "when the hearing is blank" do
    it "shouldn't be valid" do
      defendant.hearing = ""
      defendant.should_not be_valid
    end
  end
end
