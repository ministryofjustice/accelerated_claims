describe Possession, :type => :model do
  let(:defendant) { Possession.new(hearing: 'Yes') }

  describe "when a hearing is provided" do
    it "should be valid" do
      expect(defendant).to be_valid
    end
  end

  describe "when a hearing is not provided" do
    it "should be valid" do
      defendant.hearing = 'No'
      expect(defendant).to be_valid
    end
  end

  describe "when the hearing is blank" do
    it "shouldn't be valid" do
      defendant.hearing = ""
      expect(defendant).not_to be_valid
    end
  end

  describe "#as_json" do
    let(:desired_format) { { "hearing" => 'Yes' } }

    it "should produce formatted output" do
      expect(defendant.as_json).to eq desired_format
    end
  end
end
