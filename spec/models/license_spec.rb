require 'spec_helper'

describe License do
  let(:license) do
    License.new(hmo: true,
                authority: "Westminster City",
                hmo_date: "1 1 2013",
                housing_act: true,
                housing_act_authority: "Westminster City",
                housing_act_date: "1 1 2013")
  end

  describe "#as_json" do
    let(:desired_format) do
      {
        "hmo" => true,
        "authority" => "Westminster City",
        "hmo_day" => "01",
        "hmo_month" => "01",
        "hmo_year" => "2013",
        "housing_act" => true,
        "housing_act_authority" => "Westminster City",
        "housing_act_date_day" => "01",
        "housing_act_date_month" => "01",
        "housing_act_date_year" => "2013"
      }
    end

    it "should produce formatted output" do
      expect(license.as_json).to eq desired_format
    end
  end

  describe "when given all valid values" do
    it "should be valid" do
      license.should be_valid
    end
  end

  describe "house in multiple occupation value" do
    it "can't be blank" do
      license.hmo = ""
      license.should_not be_valid
    end

    describe "when HMO is present" do
      before { license.authority = "" }

      it "should require authority name" do
        license.should_not be_valid
      end
    end
  end

  describe "the value for Housing Act 2004" do
    it "can't be blank" do
      license.housing_act = ""
      license.should_not be_valid
    end

    describe "when property is licensed under Part 3 of Housing Act 2004" do
      before { license.housing_act_authority = "" }

      it "should require housing act authority" do
        license.should_not be_valid
      end
    end
  end
end
