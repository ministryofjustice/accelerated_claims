require 'spec_helper'

describe License do

  let(:license) do
    License.new({
        multiple_occupation: multiple_occupation,
        issued_under_act_part: issued_under_act_part,
        issued_by: issued_by,
      }.merge(
        form_date 'issued_date', issued_date
      )
    )
  end

  subject { license }

  context 'in multiple occupation' do
    let(:multiple_occupation) { 'Yes' }
    let(:issued_by) { 'Westminster City' }
    let(:issued_date) { Date.parse("2013-01-12") }
    let(:issued_under_act_part) { 'Part2' }

    context 'and licensed under part 2 of act' do
      it { should be_valid }
      its(:as_json) { should == {
          "hmo" => 'Yes',
          "authority" => issued_by,
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
      let(:issued_under_act_part) { 'Part3' }
      it { should be_valid }
      its(:as_json) { should == {
          "hmo" => 'No',
          "authority" => '',
          "hmo_day" => '',
          "hmo_month" => '',
          "hmo_year" => '',
          "housing_act" => 'Yes',
          "housing_act_authority" => issued_by,
          "housing_act_date_day" => '12',
          "housing_act_date_month" => '01',
          "housing_act_date_year" => '2013'
        }
      }
    end

    context 'and issued_under_act_part invalid' do
      let(:issued_under_act_part) { 'Part100' }
      it { should_not be_valid }
    end

    context 'and issued_under_act_part blank' do
      let(:issued_under_act_part) { '' }
      it { should_not be_valid }
    end

    context 'and issued_by blank' do
      let(:issued_by) { '' }
      it { should_not be_valid }
    end

    context 'and issued_date blank' do
      let(:issued_date) { '' }
      it { should_not be_valid }
    end
  end

  context 'not in multiple occupation' do
    let(:multiple_occupation) { 'No' }
    let(:issued_date) { '' }
    let(:issued_by) { '' }
    let(:issued_under_act_part) { '' }

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
