describe ClaimantCollection do

  def claim_params
    HashWithIndifferentAccess.new(
      { "num_claimants" => 3,
        "claimant_type" => 'individual',
        'javascript_enabled' => true,
        "claimant_1" =>
        {
          "title" => "Mr",
          "full_name" => "John Smith 1st",
          "street" => "2 Brown St\nCwmbran",
          "postcode" => "SW1W 0LU"
        },
        "claimant_2" =>
        {
          "title" => "Mr",
          "full_name" => "John Smith 2nd",
          "street" => "2 Brown St\nCwmbran",
          "postcode" => "SW1W 0LU",
          "address_same_as_first_claimant" => 'No'
        },
        "claimant_3" =>
        {
          "title" => "Mr",
          "full_name" => "John Smith 3rd",
          "street" => "2 Brown St\nCwmbran",
          "postcode" => "SW1W 0LU",
          "address_same_as_first_claimant" => 'No'
        }
      }
    )
  end

  def test_claimant_4
    {
      "claimant_4" =>
      {
        "title" => "Mr",
        "full_name" => "John Smith 4th",
        "address_same_as_first_claimant" => 'Yes',
        "street" => nil,
        "postcode" => nil
      }
    }
  end

  let(:params) { claim_params }
  let(:claimants) { ClaimantCollection.new(params) }

  describe '.new' do
    it 'should instantiate a collection with the correct number of claimants' do
      expect(claimants).to be_instance_of ClaimantCollection
      expect(claimants.size).to eq 3
    end

    it 'first claimant has first_claimant set true' do
      expect(claimants[1].first_claimant?).to eq true
    end

    it 'second and third claimant has first_claimant set false' do
      expect(claimants[2].first_claimant?).to eq false
      expect(claimants[3].first_claimant?).to eq false
    end

    context 'with number of claimants in the params less than the number given in the initializer' do
      let(:params) { claim_params.merge(num_claimants: 4) }

      it 'should fail' do
        expect(claimants).not_to be_valid
        expected_errors = [
              "Claimant 4 full name Enter claimant 4's full name",
              "Claimant 4 address same as first claimant You must specify whether claimant 4's address is the same as the first claimant"
            ]
        expect(claimants.errors.full_messages).to eq expected_errors
      end
    end

    context 'with empty params' do
      let(:params) { {} }
      it 'should return size of zero with 1 empty claimant' do
        expect(claimants.size).to eq 0
      end
    end

    context 'with number of claimants 2' do
      let(:params) do
        params = claim_params
        params['num_claimants'] = 2
        params
      end

      it 'has size equal to 2' do
        expect(claimants.size).to eq 2
      end

      describe 'first two claimants' do
        it 'have validate absence set to false' do
          expect(claimants[1].validate_absence?).to be false
          expect(claimants[2].validate_absence?).to be false
        end

        it 'are valid' do
          expect(claimants[1].valid?).to be true
          expect(claimants[2].valid?).to be true
        end
      end

      describe 'remaining claimants' do
        it 'have validate absence set to true' do
          expect(claimants[3].validate_absence?).to be true
          expect(claimants[4].validate_absence?).to be true
        end

        it 'is not valid if details are provided' do
          expect(claimants[3].valid?).to be false
        end

        it 'is valid if details are blank' do
          expect(claimants[4].valid?).to be true
        end
      end
    end
  end

  describe '#[]' do
    it 'should return the claimant of the given index' do
      claimant = claimants[2]
      expect(claimant).to be_instance_of(Claimant)
      expect(claimant.full_name).to eq "John Smith 2nd"
    end

    it 'should raise error if index 0 is given' do
      expect {
        claimants[0]
      }.to raise_error ArgumentError, "No such index: 0"
    end

    it 'should return empty claimant if the index is higher than the number of claimants' do
      claimant = claimants[4]
      expect(claimant.empty?).to be true
    end
  end

  describe '#[]=' do

    let(:claimant) {
      Claimant.new( title: "Mrs", full_name: "Maggie Thatcher",
          street: "10 Downing Street St\nLondon", postcode: "SW1W 0LU" )
    }
    it 'should raise error if index is zero' do
      expect {
        claimants[0] = claimant
      }.to raise_error ArgumentError, "Invalid index: 0"
    end

    it 'should raise error if index is greater than number of claimants' do
      expect {
        claimants[4] = claimant
      }.to raise_error ArgumentError, "Invalid index: 4"
    end

    it 'should replace the specified claimant with the new claimant' do
      claimants[3] = claimant
      c = claimants[3]
      expect(c.full_name).to eq 'Maggie Thatcher'
    end
  end

  describe 'as_json' do
    it 'should produce a json representation of the contacts' do
      expect(claimants.as_json).to eq expected_claimant_collected_json(claimants)
    end
  end

  describe '.max_claimants' do
    it 'should return the maximum number of claimants' do
      expect(ClaimantCollection.max_claimants).to eq 4
    end
  end

  describe '.participant_type' do
    it 'should return claimant' do
      expect(ClaimantCollection.participant_type).to eq 'claimant'
    end
  end

  context 'instantiating with an empty array' do
    let(:params) { HashWithIndifferentAccess.new }

    subject { claimants }
    it { expect(claimants.size).to eq 0  }
    it { expect(claimants.further_participants).to be_empty }

    it 'should intantiate a collection of 4 empty objects' do
      expect(claimants[1]).to eq Claimant.new('claimant_num' => 1, 'validate_address_same_as_first_claimant' => false)
      expect(claimants[2]).to eq Claimant.new('claimant_num' => 2, 'validate_address_same_as_first_claimant' => false)
      expect(claimants[3]).to eq Claimant.new('claimant_num' => 3, 'validate_address_same_as_first_claimant' => false)
      expect(claimants[4]).to eq Claimant.new('claimant_num' => 4, 'validate_address_same_as_first_claimant' => false)
    end
  end

  context 'one claimant' do
    let(:params) do
      params = claim_params
      params.delete('claimant_2')
      params.delete('claimant_3')
      params['num_claimants'] = 1
      params
    end
    subject { claimants }
    it { expect(claimants.size).to eq 1  }
    it { expect(claimants.further_participants).to be_empty }
  end

  context 'two claimants' do
    let(:params) do
      params = claim_params
      params.delete('claimant_3')
      params['num_claimants'] = 2
      params
    end
    subject { claimants }
    it { expect(claimants.size).to eq 2  }
    it { expect(claimants.further_participants).to be_empty }
  end

  context 'three claimants' do
    subject { claimants }
    it { expect(claimants.size).to eq 3  }
    it { expect(claimants.further_participants).to eq [ claimants[3] ]  }
  end

  context 'four claimants' do
    let(:params) do
      params = claim_params
      params.merge!(test_claimant_4)
      params['num_claimants'] = 4
      params
    end
    subject { claimants }
    it { expect(claimants.size).to eq 4  }
    it { expect(claimants.further_participants).to eq [ claimants[3], claimants[4] ]  }

    context 'and last claimant has address same as first claimant' do
      it { is_expected.to be_valid }

      it 'should have first claimants address set on last claimant' do
        expect(claimants[4].street).to eq claimants[1].street
        expect(claimants[4].postcode).to eq claimants[1].postcode
      end
    end
  end

end

def expected_claimant_collected_json(claimants)
  {'claimant_1' => claimants[1].as_json, 'claimant_2' => claimants[2].as_json, 'claimant_3' => claimants[3].as_json }.as_json
end

