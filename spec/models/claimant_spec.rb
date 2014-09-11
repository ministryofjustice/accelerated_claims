describe Claimant, :type => :model do

  def individual_params
    HashWithIndifferentAccess.new(
      title: 'Mr',
      full_name: "John Doe",
      street: "Streety Street\nLondon",
      postcode: "SW1H9AJ",
      claimant_type: 'individual',
      claimant_num: 1
    )
  end

  def organisation_params
    individual_params.merge(
      title: nil,
      full_name: nil,
      organization_name: 'Anytown Council Housing Departement',
      claimant_type: 'organization',
      claimant_num: 2
    )
  end

  let(:claimant) { Claimant.new(claimant_params) }

  context 'equality comparison' do
    it 'should be true if two new objects are compared with one another' do
      c1 = Claimant.new
      c2 = Claimant.new
      expect(c1).to eq c2
    end

    it 'should be true for two claimants with the same values' do
      c1 = Claimant.new( individual_params )
      c2 = Claimant.new( individual_params )
      expect(c1).to eq c2
    end

    it 'should be false if any of the instance variables are different' do
      c1 = Claimant.new( individual_params )
      c2 = Claimant.new( individual_params.merge("title" => "XXX") )
      expect(c1).not_to eq c2
    end
  end

  describe '#indented_details' do
    it 'should return a string containting name and address with each line indented by the required number of spaces'  do
      expected = "    Mr John Doe\n    Streety Street\n    London\n    SW1H 9AJ\n"
      expect(claimant.indented_details(4)).to eq expected
    end
  end

  context 'validate_absence set to true' do
    let(:claimant_params) { individual_params }
    subject { claimant }

    context 'when all attributes are empty' do
      let(:claimant_params) { { validate_absence: true, claimant_num: 1 } }
      it { is_expected.to be_valid }
    end

    context 'when attributes are present' do
      let(:claimant_params) { individual_params.merge(validate_absence: true) }
      it { is_expected.to_not be_valid }
    end
  end

  context 'claimant_type organization' do
    let(:claimant_params) { organisation_params }
    subject { claimant }
    it { is_expected.to be_valid }

    describe 'mandatory fields for organizations are present' do
      it 'should not be valid if organization name is missing' do
        claimant.organization_name = nil
        expect(claimant).not_to be_valid
        expect(claimant.errors[:organization_name]).to eq ["Enter claimant 2's company name or local authority name"]
      end

      it 'should not be valid if street is missing' do
        claimant.street = nil
        expect(claimant).not_to be_valid
        expect(claimant.errors[:street]).to eq ["Enter claimant 2's full address"]
      end

      it 'should not be valid if the postcocde is missing' do
        claimant.postcode = nil
        expect(claimant).not_to be_valid
        expect(claimant.errors[:postcode]).to eq ["Enter claimant 2's postcode"]
      end
    end
  end

  context 'claimant_type individual' do
    let(:claimant_params) { individual_params.merge(claimant_num: 2) }

    it 'should set the validate_presence attribute to true if missing' do
      expect(claimant.validate_presence).to be true
    end

    it 'should be valid if all attributes are set' do
      expect(claimant).to be_valid
    end

    it 'should not be valid if any of the attributes is missing' do
      claimant.full_name = nil
      claimant.street = nil
      expect(claimant).to_not be_valid
      expect(claimant.errors[:full_name]).to eq [ "Enter claimant 2's full name" ]
      expect(claimant.errors[:street]).to eq ["Enter claimant 2's full address"]
    end

    it 'should not be valid if any of the attributes are blank' do
      claimant.title = ''
      claimant.full_name = ''
      claimant.street = ''
      claimant.postcode = ''
      expect(claimant).to_not be_valid
      expect(claimant.errors[:title]).to eq ["Enter claimant 2's title"]
      expect(claimant.errors[:full_name]).to eq ["Enter claimant 2's full name"]
      expect(claimant.errors[:street]).to eq ["Enter claimant 2's full address"]
      expect(claimant.errors[:postcode]).to eq ["Enter claimant 2's postcode"]
    end

    describe 'address validation' do
      it 'should not validate when postcode is incomplete' do
        claimant.postcode = 'SW10'
        expect(claimant).not_to be_valid
        expect(claimant.errors[:postcode]).to eq ["claimant 2's postcode is not a full postcode"]
      end

      it 'should not validate when postcode is invalid' do
        claimant.postcode = 'SW10XX 5FF'
        expect(claimant).not_to be_valid
        expect(claimant.errors[:postcode]).to eq ["is too long (maximum is 8 characters)", "Enter a valid postcode for claimant 2"]
      end

      it 'should not validate when street is too long' do
        claimant.street = "x" * 72
        expect(claimant).not_to be_valid
        expect(claimant.errors[:street]).to eq ["is too long (maximum is 70 characters)"]
      end
    end
  end

  describe '#numbered_claimant_header' do
    it 'should print claimant_x where x is the number of hte claimant' do
      claimant = Claimant.new(HashWithIndifferentAccess.new(title: 'Mr', full_name: "John Doe", street: "Streety Street\nLondon", postcode: "SW1H9AJ", claimant_type: 'individual', claimant_num: 3))
      expect(claimant.numbered_header).to eq "Claimant 3:\n"
    end
  end

end
