require 'spec_helper'

describe License do
  let(:license) do
    License.new(multiple_occupation: 'Yes',
                multiple_occupation_authority: "Westminster City",
                multiple_occupation_date: Date.parse("2013-01-01"),
                housing_act: 'Yes',
                housing_act_authority: "Westminster City",
                housing_act_date: Date.parse("2013-01-01")
              )
  end

  let(:desired_format) do
    {
      "hmo" => 'Yes',
      "authority" => "Westminster City",
      "hmo_day" => "01",
      "hmo_month" => "01",
      "hmo_year" => "2013",
      "housing_act" => 'Yes',
      "housing_act_authority" => "Westminster City",
      "housing_act_date_day" => "01",
      "housing_act_date_month" => "01",
      "housing_act_date_year" => "2013"
    }
  end

  describe "#as_json" do
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
      license.multiple_occupation = ""
      license.should_not be_valid
    end

    describe "when HMO is present" do
      before { license.multiple_occupation_authority = "" }

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

  describe "the housing act date value" do
    it "can be blank" do
      license.housing_act_date = nil
      json_mod = { 
        'housing_act_date_day' => '', 
        'housing_act_date_month' => '', 
        'housing_act_date_year' => '' 
      }
      expect(license.as_json).to eql desired_format.merge(json_mod)
    end
  end

  describe "the multiple_occupation_date value" do
    it "can be blank" do
      license.multiple_occupation_date = nil
      json_mod = {
        'hmo_day' => '', 
        'hmo_month' => '', 
        'hmo_year' => ''
      }
      expect(license.as_json).to eql desired_format.merge(json_mod)
    end
  end
end
