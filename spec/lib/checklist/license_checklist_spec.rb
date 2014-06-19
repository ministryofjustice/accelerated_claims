describe LicenseChecklist do
  describe '#add' do
    # let(:json) do
    #   data = claim_formatted_data
    #   data['required_documents'] = ''
    #   data
    # end
    # let(:license) { LicenseChecklist.new(json).add['required_documents'] }
    let(:section2) { "- Evidence of your HMO license application issued under part 2 of the Housing Act 2004 - marked 'D'\n\n" }
    let(:section3) { "- Evidence of your HMO license application issued under part 3 of the Housing Act 2004 - marked 'E'\n\n" }


    context 'HMO licence applied for' do 
      it 'should add the section 2 text when section 2 is chosen' do
        formatted_data = LicenseChecklist.new(section_2_applied_for).add
        formatted_data['required_documents'].should == section2
      end

      it 'should add the section 3 text when section 3 chosen' do
        formatted_data = LicenseChecklist.new(section_3_applied_for).add
        formatted_data['required_documents'].should == section3
      end
    end



    context 'HMO licence held' do
      it 'should not add anything when section 2 is chosen' do
        formatted_data = LicenseChecklist.new(section_2_held).add
        formatted_data['required_documents'].should be_empty
      end

      it 'should not add anything when section 3 is chosen' do
        formatted_data = LicenseChecklist.new(section_3_held).add
        formatted_data['required_documents'].should be_empty
      end
    end


    context 'HMO licence no Applicable' do
      it 'should not add anything when section 2 is chosen' do
        formatted_data = LicenseChecklist.new(hmo_not_applicable).add
        formatted_data['required_documents'].should be_empty
      end
    end


  end
end

def hmo_not_applicable
  claim_formatted_data.merge({ 
    'required_documents'          => '',
    'license_multiple_occupation' => 'No',
    'license_part2_authority'     => '',
    'license_part2_day'           => '',
    'license_part2_month'         => '',
    'license_part2_year'          => '',
    'license_part3'               => 'No',
    'license_part3_authority'     => '',
    'license_part3_day'           => '',
    'license_part3_month'         => '',
    'license_part3_year'          => ''
     })
end


def section_2_held
  claim_formatted_data.merge({ 
    'required_documents'          => '',
    'license_multiple_occupation' => 'Yes',
    'license_part2_authority'     => 'Westeros',
    'license_part2_day'           => '01',
    'license_part2_month'         => '01',
    'license_part2_year'          => '2014',
    'license_part3'               => 'No',
    'license_part3_authority'     => '',
    'license_part3_day'           => '',
    'license_part3_month'         => '',
    'license_part3_year'          => ''
     })
end


def section_3_held
  claim_formatted_data.merge({ 
    'required_documents'          => '',
    'license_multiple_occupation' => 'No',
    'license_part2_authority'     => '',
    'license_part2_day'           => '',
    'license_part2_month'         => '',
    'license_part2_year'          => '',
    'license_part3'               => 'Yes',
    'license_part3_authority'     => 'RBKC',
    'license_part3_day'           => '13',
    'license_part3_month'         => '08',
    'license_part3_year'          => '2012'
     })
end

def section_2_applied_for
  claim_formatted_data.merge({ 
    'required_documents'          => '',
    'license_multiple_occupation' => 'Yes',
    'license_part3'               => 'No',
    'license_part2_authority'     => '',
    'license_part2_day'           => '',
    'license_part2_month'         => '',
    'license_part2_year'          => '' })
end

def section_3_applied_for
  claim_formatted_data.merge({ 
    'required_documents'          => '',
    'license_multiple_occupation' => '',
    'license_part3'               => 'Yes',
    'license_part3_authority'     => '',
    'license_part3_day'           => '',
    'license_part3_month'         => '',
    'license_part3_year'          => '' })
end




