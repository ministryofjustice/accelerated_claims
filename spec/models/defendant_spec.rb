require 'spec_helper'

describe Defendant do
  let(:defendant) do
    Defendant.new(title: "Mr",
                  full_name: "John Major",
                  street: "Sesame Street",
                  town: "London",
                  postcode: "SW1X 2PT")
  end

  describe "when given all valid values" do
    it "should be valid" do
      defendant.should be_valid
    end
  end

  context 'when validate_presence false' do
    before do
      defendant.validate_presence = false
    end
    describe "full_name name" do
      it "when blank" do
        defendant.full_name = ""
        defendant.should be_valid
      end

      it "when over 40 characters" do
        defendant.title = "x" * 9
        defendant.should_not be_valid
      end
    end
  end

  context 'when validate_presence true' do
    before do
      defendant.validate_presence = true
    end
    describe "full_name name" do
      it "when blank" do
        defendant.full_name = ""
        defendant.should_not be_valid
      end

      it "when over 40 characters" do
        defendant.title = "x" * 9
        defendant.should_not be_valid
      end
    end
  end

  describe "#as_json" do
    let(:desired_format) do
      {
        "address" => "Mr John Major\nSesame Street\nLondon",
        "postcode1" => "SW1X",
        "postcode2" => "2PT"
      }
    end

    it "should generate the correct JSON" do
      defendant.as_json.should eq desired_format
    end
  end
end
