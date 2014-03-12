require 'spec_helper'

describe License do

  let(:license) do
    License.new({
        multiple_occupation: multiple_occupation,
        license_issued_under: license_issued_under,
        license_issued_by: license_issued_by,
      }.merge(
        form_date 'license_issued_date', license_issued_date
      )
    )
  end

  subject { license }

  context 'in multiple occupation' do
    let(:multiple_occupation) { 'Yes' }
    let(:license_issued_by) { 'Westminster City' }
    let(:license_issued_date) { Date.parse("2013-01-12") }
    let(:license_issued_under) { 'Part2' }

    context 'and licensed under part 2 of act' do
      it { should be_valid }
      its(:as_json) { should == {
          "hmo" => 'Yes',
          "authority" => license_issued_by,
          "hmo_day" => '12',
          "hmo_month" => '01',
          "hmo_year" => '2013',
          "housing_act" => 'No',
          "housing_act_authority" => '',
          "housing_act_date_day" => '',
          "housing_act_date_month" => '',
          "housing_act_date_year" => ''
        }
      }
    end

    context 'and licensed under part 3 of act' do
      let(:license_issued_under) { 'Part3' }
      it { should be_valid }
      its(:as_json) { should == {
          "hmo" => 'No',
          "authority" => '',
          "hmo_day" => '',
          "hmo_month" => '',
          "hmo_year" => '',
          "housing_act" => 'Yes',
          "housing_act_authority" => license_issued_by,
          "housing_act_date_day" => '12',
          "housing_act_date_month" => '01',
          "housing_act_date_year" => '2013'
        }
      }
    end

    context 'and license_issued_under invalid' do
      let(:license_issued_under) { 'Part100' }
      it { should_not be_valid }
    end

    context 'and license_issued_under blank' do
      let(:license_issued_under) { '' }
      it { should_not be_valid }
    end

    context 'and license_issued_by blank' do
      let(:license_issued_by) { '' }
      it { should_not be_valid }
    end

    context 'and license_issued_date blank' do
      let(:license_issued_date) { '' }
      it { should_not be_valid }
    end
  end

  context 'not in multiple occupation' do
    let(:multiple_occupation) { 'No' }
    let(:license_issued_date) { '' }
    let(:license_issued_by) { '' }
    let(:license_issued_under) { '' }

    it { should be_valid }

    its(:as_json) { should == {
        "hmo" => 'No',
        "authority" => '',
        "hmo_day" => '',
        "hmo_month" => '',
        "hmo_year" => '',
        "housing_act" => 'No',
        "housing_act_authority" => '',
        "housing_act_date_day" => '',
        "housing_act_date_month" => '',
        "housing_act_date_year" => ''
      }
    }
  end

end
