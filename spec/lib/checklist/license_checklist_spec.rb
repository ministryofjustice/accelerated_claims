describe LicenseChecklist do
  describe '#add' do

    context 'HMO licence applied for' do 

      let(:section2) { "- evidence of your HMO licence application - marked 'D'\n\n" }
      let(:section3) { "- evidence of your HMO licence application - marked 'E'\n\n" }

      it 'should add the section 2 text when section 2 is chosen' do
        formatted_data = LicenseChecklist.new(section_2_applied_for).add
        expect(formatted_data['required_documents']).to eq section2
      end

      it 'should add the section 3 text when section 3 chosen' do
        formatted_data = LicenseChecklist.new(section_3_applied_for).add
        expect(formatted_data['required_documents']).to eq section3
      end
    end



    context 'HMO licence held' do
      it 'should not add anything when section 2 is chosen' do
        formatted_data = LicenseChecklist.new(section_2_held).add
        expect(formatted_data['required_documents']).to be_empty
      end

      it 'should not add anything when section 3 is chosen' do
        formatted_data = LicenseChecklist.new(section_3_held).add
        expect(formatted_data['required_documents']).to be_empty
      end
    end


    context 'HMO licence no Applicable' do
      it 'should not add anything when section 2 is chosen' do
        formatted_data = LicenseChecklist.new(hmo_not_applicable).add
        expect(formatted_data['required_documents']).to be_empty
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




