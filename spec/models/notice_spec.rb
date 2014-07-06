describe Notice, :type => :model do
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
      expect(notice).to be_valid
    end
  end

  describe "served_by_name" do
    it "should be required" do
      notice.served_by_name = ""
      expect(notice).not_to be_valid
    end

    it "should be up to 40 characters" do
      notice.served_by_name = "x" * 41
      expect(notice).not_to be_valid
    end
  end

  describe "served_method" do
    it "should be required" do
      notice.served_method = ""
      expect(notice).not_to be_valid
    end

    it "should be up to 40 characters" do
      notice.served_method = "x" * 41
      expect(notice).not_to be_valid
    end
  end

  describe "date served" do
    it "should be provided" do
      notice.date_served = ""
      expect(notice).not_to be_valid
    end
  end

  describe "expiry date" do
    it "should be provided" do
      notice.expiry_date = ""
      expect(notice).not_to be_valid
    end
  end

  context 'date_validation' do
    it 'should raise if the expiry date is same as served date' do
      notice.expiry_date = notice.date_served
      expect(notice).not_to be_valid
      expect(notice.errors["expiry_date"]).to eq(["must be later than the Date notice served "])
    end

    it 'should raise if the expiry date is before the served date' do
      notice.expiry_date = notice.date_served - 10
      expect(notice).not_to be_valid
      expect(notice.errors["expiry_date"]).to eq(["must be later than the Date notice served "])
    end

    it 'should not raise if the expiry date is exactly 2 months after the served date' do
      notice.date_served = Date.new(2014, 4, 4)
      notice.expiry_date = Date.new(2014, 6, 3)
      expect(notice).to be_valid
    end


    it 'should not raise if the expiry date is more than 2 months after the served date' do
      notice.date_served = Date.new(2014, 4, 4)
      notice.expiry_date = Date.new(2014, 6, 4)
      expect(notice).to be_valid
    end

    it 'should  raise if the expiry date is less than 2 months after the served date' do
      notice.date_served = Date.new(2014, 4, 4)
      notice.expiry_date = Date.new(2014, 6, 2)
      expect(notice).not_to be_valid
    end

  end

end
