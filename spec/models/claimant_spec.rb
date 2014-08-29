describe Claimant, :type => :model do

  let(:claimant_params)  { HashWithIndifferentAccess.new(title: 'Mr', full_name: "John Doe", street: "Streety Street\nLondon", postcode: "SW1H9AJ",  claimant_type: 'individual', claimant_num: 1) }
  let(:claimant)         { Claimant.new(claimant_params) }

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
      expect(claimant.errors[:full_name]).to eq [ "Enter claimant 1's full name" ]
    end
  end

  
  context 'equality comparison' do

    it 'should be true if two new objects are compared with one another' do
      c1 = Claimant.new
      c2 = Claimant.new
      expect(c1).to eq c2
    end

    it 'should be true for two claimants with the same values' do
      c1 = Claimant.new( { "title" => "Mrs", "full_name" => "Maggie Thatcher", "street" => "10 Downing Street St\nLondon", "postcode" => "SW1W 0LU"} )
      c2 = Claimant.new( { "title" => "Mrs", "full_name" => "Maggie Thatcher", "street" => "10 Downing Street St\nLondon", "postcode" => "SW1W 0LU"} )
      expect(c1).to eq c2
    end

    it 'should be false if any of the instance variables are different' do
      c1 = Claimant.new( { "title" => "Mrs", "full_name" => "Maggie Thatcher", "street" => "10 Downing Street St\nLondon", "postcode" => "SW1W 0LU"} )
      c2 = Claimant.new( { "title" => "XXX", "full_name" => "Maggie Thatcher", "street" => "10 Downing Street St\nLondon", "postcode" => "SW1W 0LU"} )
      expect(c1).not_to eq c2
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
      expect(claimant.errors[:street]).to eq ["Enter claimant 1's full address"]
    end

    it 'should not be valid if any of the attributes are blank' do
      claimant.postcode = ''
      expect(claimant).to_not be_valid
      expect(claimant.errors[:postcode]).to eq ["Enter claimant 1's postcode"]
    end
  end


  context 'ccc' do
    it 'should not validate if validate presence true but attrs are blank' do
      claimant = Claimant.new(HashWithIndifferentAccess.new(claimant_type: 'individual', validate_presence: true, full_name: '', num_claimants: 1, postcode: '', street: '', title: '', claimant_num: 2))
      expect(claimant).not_to be_valid
      expect(claimant.errors[:title]).to eq ["Enter claimant 2's title"]
      expect(claimant.errors[:full_name]).to eq ["Enter claimant 2's full name"]
      expect(claimant.errors[:street]).to eq ["Enter claimant 2's full address"]
      expect(claimant.errors[:postcode]).to eq ["Enter claimant 2's postcode"]
    end
  end


  context 'validate_absence set to false' do

    let(:empty_claimant)  {  Claimant.new(HashWithIndifferentAccess.new(claimant_num: 1, :validate_absence => true, claimant_num: 2 ))  }

    it 'should be valid if all fields are empty' do
      expect(empty_claimant).to be_valid
    end

    it 'should not be valid if any of the attributes are entered' do
      empty_claimant.street = 'Petty France'
      expect(empty_claimant).to_not be_valid
      expect(empty_claimant.errors.full_messages).to eq ['Street must not be entered if number of claimants is 1']
    end
  end


  context 'mandatory fields for organizations are present' do
    let(:org) { Claimant.new(HashWithIndifferentAccess.new(organization_name: 'Anytown Council Housing Departement', street: "Streety Street\nLondon", postcode: "SW1H9AJ", claimant_type: 'organization', claimant_num: 2)) }

    it 'should not be valid if organization name is missing' do
      org.organization_name = nil
      expect(org).not_to be_valid
      expect(org.errors[:organization_name]).to eq ["Enter claimant 2's company name or local authority name"]
    end

    it 'should not be valid if street is missing' do
      org.street = nil
      expect(org).not_to be_valid
      expect(org.errors[:street]).to eq ["Enter claimant 2's full address"]
    end


    it 'should not be valid if the postcocde is missing' do
      org.postcode = nil
      expect(org).not_to be_valid
      expect(org.errors[:postcode]).to eq ["Enter claimant 2's postcode"]
    end

    it 'should be valid if all fields are entered' do
      expect(org).to be_valid
    end
  end

  context 'mandatory fields for individuals are present' do
    let(:indiv) { Claimant.new(HashWithIndifferentAccess.new(title: 'Mr', full_name: "John Doe", street: "Streety Street\nLondon", postcode: "SW1H9AJ", claimant_type: 'individual', claimant_num: 2)) }

    it 'should be valid if all required fields are present' do
      expect(indiv).to be_valid
    end

    it 'should not be valid if full name is missing' do
      indiv.full_name = nil
      expect(indiv).not_to be_valid
      expect(indiv.errors[:full_name]).to eq ["Enter claimant 2's full name"]
    end

    it 'should not be valid if full name is missing' do
      indiv.street = nil
      expect(indiv).not_to be_valid
      expect(indiv.errors[:street]).to eq ["Enter claimant 2's full address"]
    end

    it 'should not be valid if postcode is missing' do
      indiv.postcode = nil
      expect(indiv).not_to be_valid
      expect(indiv.errors[:postcode]).to eq ["Enter claimant 2's postcode"]
    end

  end


  context 'address validation' do
    let(:claimant)  { Claimant.new(HashWithIndifferentAccess.new(title: 'Mr', full_name: "John Doe", street: "Streety Street\nLondon", postcode: "SW1H9AJ", claimant_type: 'individual', claimant_num: 2)) }

    it 'should not validate if postcode is incomplete' do
      claimant.postcode = 'SW10'
      expect(claimant).not_to be_valid
      expect(claimant.errors[:postcode]).to eq ["claimant 2's postcode is not a full postcode"]
    end    

    it 'should not validate if postcode is invalid' do
      claimant.postcode = 'SW10XX 5FF'
      expect(claimant).not_to be_valid
      expect(claimant.errors[:postcode]).to eq ["is too long (maximum is 8 characters)", "Enter a valid postcode for claimant 2"]
    end

    it 'should not validate if street is too long' do
      claimant.street = "x" * 72
      expect(claimant).not_to be_valid
      expect(claimant.errors[:street]).to eq ["is too long (maximum is 70 characters)"]
    end

  end


end
