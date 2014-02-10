require 'spec_helper'

describe ClaimData do
  context "when given data for a claim" do
    let(:data) { claim_post_data }

    let(:desired_format) do
      {
        "property"           => "Mucho Gracias Road, London",
        "property_postcode1" => "SW1H",
        "property_postcode2" => "9AJ"
      }
    end

    it "should format it so that a PDF form can be filled" do
      ClaimData.new(data).formatted.should eq desired_format
    end
  end
end
