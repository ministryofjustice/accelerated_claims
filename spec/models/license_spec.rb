describe License do

  let(:license) do
    License.new({
        multiple_occupation: multiple_occupation,
        issued_under_act_part_yes: issued_under_act_part_yes,
        issued_under_act_part_applied: issued_under_act_part_applied,
        issued_by: issued_by,
      }.merge(
        form_date 'issued_date', issued_date
      )
    )
  end

  subject { license }

  context 'licence applied for' do
    let(:multiple_occupation)           { 'Applied' }
    let(:issued_under_act_part_yes)     { '' }
    let(:issued_by)                     { '' }
    let(:issued_date)                   { '' }

    context 'no part 2 or part 3 selected' do 
      let(:issued_under_act_part_applied) { '' }
      it { should_not be_valid }
    end


    context 'and licensed under part 2 of act' do
      let(:issued_under_act_part_applied)   { 'Part2' }
      it { should be_valid }
      its(:as_json) { should == {
          "multiple_occupation" => 'Yes',
          "part2_authority"     => '',
          "part2_day"           => '',
          "part2_month"         => '',
          "part2_year"          => '',
          "part3"               => 'No',
          "part3_authority"     => '',
          "part3_day"           => '',
          "part3_month"         => '',
          "part3_year"          => ''
        }
      }
    end

    context 'and licensed under part 3 of act' do
      let(:issued_under_act_part_applied)   { 'Part3' }
      it { should be_valid }
      its(:as_json) { should == {
          "multiple_occupation" => 'No',
          "part2_authority"     => '',
          "part2_day"           => '',
          "part2_month"         => '',
          "part2_year"          => '',
          "part3"               => 'Yes',
          "part3_authority"     => '',
          "part3_day"           => '',
          "part3_month"         => '',
          "part3_year"          => ''
        }
      }
    end

    context 'and issued_under_act_part_applied invalid' do
      let(:issued_under_act_part_applied) { 'Part100' }
      it { should_not be_valid }
    end   


    context 'and issued_under_act_part_applied blank' do
      let(:issued_under_act_part_applied) { '' }
      it { should_not be_valid }
    end


  end


  context 'in multiple occupation' do
    let(:multiple_occupation)             { 'Yes' }
    let(:issued_by)                       { 'Westminster City' }
    let(:issued_date)                     { Date.parse("2013-01-12") }
    let(:issued_under_act_part_applied)   { '' }

    let(:issued_under_act_part_yes) { 'Part2' }

    context 'and licensed under part 2 of act' do
      it { should be_valid }
      its(:as_json) { should == {
          "multiple_occupation" => 'Yes',
          "part2_authority"     => issued_by,
          "part2_day"           => '12',
          "part2_month"         => '01',
          "part2_year"          => '2013',
          "part3"               => 'No',
          "part3_authority"     => '',
          "part3_day"           => '',
          "part3_month"         => '',
          "part3_year"          => ''
        }
      }
    end

    context 'and licensed under part 3 of act' do
      let(:issued_under_act_part_yes) { 'Part3' }
      it { should be_valid }
      its(:as_json) { should == {
          "multiple_occupation" => 'No',
          "part2_authority"     => '',
          "part2_day"           => '',
          "part2_month"         => '',
          "part2_year"          => '',
          "part3"               => 'Yes',
          "part3_authority"     => issued_by,
          "part3_day"           => '12',
          "part3_month"         => '01',
          "part3_year"          => '2013'
        }
      }
    end

    context 'and issued_under_act_part_yes invalid' do
      let(:issued_under_act_part_yes) { 'Part100' }
      it { should_not be_valid }
    end

 

    context 'and issued_under_act_part blank' do
      let(:issued_under_act_part_yes) { '' }
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
    let(:multiple_occupation)             { 'No' }
    let(:issued_date)                     { '' }
    let(:issued_by)                       { '' }
    let(:issued_under_act_part_yes)       { '' }
    let(:issued_under_act_part_applied)   { '' }

    it { should be_valid }

    its(:as_json) { should == {
        "multiple_occupation" => 'No',
        "part2_authority"     => '',
        "part2_day"           => '',
        "part2_month"         => '',
        "part2_year"          => '',
        "part3"               => 'No',
        "part3_authority"     => '',
        "part3_day"           => '',
        "part3_month"         => '',
        "part3_year"          => ''
      }
    }
  end

  context 'multiple occupation blank' do
    let(:multiple_occupation)               { '' }
    let(:issued_date)                       { '' }
    let(:issued_by)                         { '' }
    let(:issued_under_act_part_yes)         { '' }
    let(:issued_under_act_part_applied)     { '' }

    it { should_not be_valid }

    it 'should not have "not included in the list" error message' do
      license.valid?
      license.errors.full_messages.should == ["Multiple occupation must be selected"]
    end
  end

end
