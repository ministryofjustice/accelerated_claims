require 'spec_helper'

describe Tenant do
  let(:tenant) do
    Tenant.new(title: "Mr",
               full_name: "John Major",
               street: "Sesame Street",
               town: "London",
               postcode: "SW1")
  end

  describe "when given all valid values" do
    it "should be valid" do
      tenant.should be_valid
    end
  end

  describe "title" do
    it "when blank" do
      tenant.title = ""
      tenant.should_not be_valid
    end

    it "when over 8 characters long" do
      tenant.title = "x" * 9
      tenant.should_not be_valid
    end
  end


end
