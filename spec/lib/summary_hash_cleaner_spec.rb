describe SummaryHashCleaner do

  describe '#clean' do
    it 'should remove all manually_entered_addresses' do
      expect(SummaryHashCleaner.new(summary).clean).to eq expected_clean_summary
    end
  end
end

def summary
  summary = {
      'property' => {
        'house' => 'yes',
        'street' => 'my_street',
        'manually_entered_address' => '1'
      },
      'num_claimants' => '2',
      'claimant_1' => {
        'name' => 'A.N. Other',
      },
      'claimant_2' => {
        'name' => 'Joe Blow',
        'manually_entered_address' => '0'
      }
    }
end

def expected_clean_summary
  summary = {
      'property' => {
        'house' => 'yes',
        'street' => 'my_street'
      },
      'num_claimants' => '2',
      'claimant_1' => {
        'name' => 'A.N. Other',
      },
      'claimant_2' => {
        'name' => 'Joe Blow'
      }
    }
end

