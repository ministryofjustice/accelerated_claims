describe LicenseChecklist do
  describe '#add' do
    let(:json) do
      data = claim_formatted_data
      data['required_documents'] = ''
      data
    end
    let(:license) { LicenseChecklist.new(json).add['required_documents'] }
    let(:section2) { "* Evidence of your HMO license application issued under part 2 of Housing Act 2004 - marked 'D'\n\n" }
    let(:section3) { "* Evidence of your HMO license application issued under part 3 of Housing Act 2004 - marked 'E'\n\n" }
    let(:both_sections) do
      "* Evidence of your HMO license application

* if issued under part 2 of Housing Act 2004 - marked 'D'
* if issued under part 3 of Housing Act 2004 - marked 'E'\n\n"
    end

    context 'with HMO license' do
      context 'when section 2 is choosen' do
        before { json['license_part3'] = 'No' }

        it { expect(license).to eq section2 }
      end

      context 'when section 3 is choosen' do
        before { json['license_part3'] = 'Yes' }

        it { expect(license).to eq section3 }
      end

      context 'when all other options are left blank' do
        before do
          json['license_multiple_occupation'] = 'Yes'
          json['license_part2_authority']= ''
          json['license_part2_day']= ''
          json['license_part2_month']= ''
          json['license_part2_year']= ''
          json['license_part_year']= ''
          json['license_part3'] = ''
          json['license_part3_authority'] = ''
          json['license_part3_day'] = ''
          json['license_part3_month'] = ''
          json['license_part3_year'] = ''
        end

        it { expect(license).to eq both_sections }
      end
    end

    context 'without HMO license' do
      before do
          json['license_multiple_occupation'] = 'No'
          json['license_part2_authority']= ''
          json['license_part2_day']= ''
          json['license_part2_month']= ''
          json['license_part2_year']= ''
          json['license_part_year']= ''
          json['license_part3'] = ''
          json['license_part3_authority'] = ''
          json['license_part3_day'] = ''
          json['license_part3_month'] = ''
          json['license_part3_year'] = ''
        end

      it { expect(license).to be_blank }
    end
  end
end
