describe Notice do
  let(:notice) do
    Notice.new(served_by_name: "Jim Bob",
               served_method: "by post",
               date_served: Date.parse("2013-01-01"),
               expiry_date: Date.parse("2014-02-02"))
  end

  describe "#as_json" do
    let(:desired_format) do
      {
        "served_by" => "Jim Bob, by post",
        "date_served_day" => "01",
        "date_served_month" => "01",
        "date_served_year" => "2013",
        "expiry_date_day" => "02",
        "expiry_date_month" => "02",
        "expiry_date_year" => "2014"
      }
    end

    it "should produce formatted output" do
      expect(notice.as_json).to eq desired_format
    end
  end

  describe "when given all valid values" do
    it "should be valid" do
      notice.should be_valid
    end
  end

  describe "served_by_name" do
    it "should be required" do
      notice.served_by_name = ""
      notice.should_not be_valid
    end

    it "should be up to 40 characters" do
      notice.served_by_name = "x" * 41
      notice.should_not be_valid
    end
  end

  describe "served_method" do
    it "should be required" do
      notice.served_method = ""
      notice.should_not be_valid
    end

    it "should be up to 40 characters" do
      notice.served_method = "x" * 41
      notice.should_not be_valid
    end
  end

  describe "date served" do
    it "should be provided" do
      notice.date_served = ""
      notice.should_not be_valid
    end
  end

  describe "expiry date" do
    it "should be provided" do
      notice.expiry_date = ""
      notice.should_not be_valid
    end
  end

end
