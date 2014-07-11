describe Claimant, :type => :model do
  let(:claimant) do
    Claimant.new(title: 'Mr',
                 full_name: "John Doe",
                 street: "Streety Street\nLondon",
                 postcode: "SW1H9AJ")
  end

  subject { claimant }

  it { is_expected.to be_valid }

  context 'validate_presence not set' do

    it 'should set the validate_presence attribute to true if missing' do
      expect(claimant.validate_presence).to be true
    end

    it 'should be valid if all attributes are set ' do
      expect(claimant.validate_presence).to be true
      expect(claimant).to be_valid
    end

    it 'should not be valid if any of the attributes is missing' do
      claimant.full_name = nil
      expect(claimant).to_not be_valid
      expect(claimant.errors[:full_name]).to eq [ "Enter the claimant's full name" ]
    end
  end




  context 'validate_presence set to true' do
    
    before(:each)   { claimant.validate_presence = true }

    it 'should be valid if all attributes are set' do
      expect(claimant).to be_valid
    end

    it 'should not be valid if any of the attributes are missing' do
      claimant.street = nil
      expect(claimant).to_not be_valid
      expect(claimant.errors[:street]).to eq ["Enter the claimant's full address"]
    end

    it 'should not be valid if any of the attributes are blank' do
      claimant.postcode = ''
      expect(claimant).to_not be_valid
      expect(claimant.errors[:postcode]).to eq ["Enter the claimant's postcode"]
    end
  end


  context 'validate_absence set to false' do

    let(:empty_claimant)  {  Claimant.new( :validate_absence => true )  }

    it 'should be valid if all fields are empty' do
      expect(empty_claimant).to be_valid
    end

    it 'should not be valid if any of the attributes are entered' do
      empty_claimant.street = 'Petty France'
      expect(empty_claimant).to_not be_valid
      expect(empty_claimant.errors.full_messages).to eq ['Street must not be entered if number of claimants is 1']
    end
  end

end
