require 'spec_helper'

describe ClaimData do

  context "when given data for a claim" do
    let(:data) do
      {
        "claim" =>
        {
          "property" =>
          {
            "street"   => "Streety Street",
            "town"     => "London",
            "postcode" => "SW1H 9AJ",
            "house"    => "A house"
          }
        }
      }
    end

    let(:desired_format) do
      {
        "property"           => "Streety Street, London",
        "property_postcode1" => "SW1H",
        "property_postcode2" => "9AJ"
      }
    end

    it "should format it so that a PDF form can be filled" do
      ClaimData.new(data).formatted.should eq desired_format
    end
  end

end
