require 'spec_helper'

describe ClaimData do
  context "when given data for a claim" do
    let(:data) { claim_post_data }

    let(:desired_format) do
      {
        "property"           => "Mucho Gracias Road\nLondon",
        "property_postcode1" => "SW1H",
        "property_postcode2" => "9AJ",
        "claimant" => "Landlordly LTD\nSecret Lair 2\nEvil",
        "claimant_postcode1" => "SW1W",
        "claimant_postcode2" => "0LU"
      }
    end

    it "should format it so that a PDF form can be filled" do
      ClaimData.new(data).formatted.should eq desired_format
    end
  end
end
