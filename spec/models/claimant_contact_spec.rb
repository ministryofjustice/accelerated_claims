require 'spec_helper'

describe ClaimantContact do

  def claimant_contact options={}
    params = claim_post_data['claim']['claimant_contact'].merge(options)
    ClaimantContact.new(params)
  end

  describe "when given all valid values" do
    it "should be valid" do
      claimant_contact.should be_valid
    end
  end

  subject { claimant_contact }
  include_examples 'address validation'

  describe 'with non-number legal costs' do
    it 'should be invalid' do
      data = claimant_contact('legal_costs' => 'xx.x')
      data.should_not be_valid
      data.errors.messages[:legal_costs].first.should == 'must be a valid amount'
    end
  end

  describe 'with legal costs no decimal' do
    it 'should be valid' do
      data = claimant_contact('legal_costs' => '123')
      data.should be_valid
      data.legal_costs.should == '123'
    end
  end

  describe 'with blank legal costs' do
    it 'should be valid' do
      data = claimant_contact('legal_costs' => '')
      data.should be_valid
    end
  end

  describe "#as_json" do
    let(:json_output) do
      {
        "address" => "Mr Jim Brown\n3 Smith St\nWinsum",
        "dx_number" => "DX 123",
        "email" => "jim@example.com",
        "fax" => "020 000 000",
        "phone" => "020 000 000",
        "postcode1" => "SW1W",
        "postcode2" => "0LU",
        "reference_number" => "my-ref-123",
        "legal_costs" => '123.34'
      }
    end

    it "should produce formated output" do
      claimant_contact.as_json.should eq json_output
    end
  end

end
