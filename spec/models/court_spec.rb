RSpec.describe Court, :type => :model do

  let(:court) do
    Court.new(court_name: 'Good Court',
              street: '1 Good Road,Goodtown',
              postcode: 'GT1 2XX')
  end

  it 'should be valid with all the attributes' do
    court.valid?
    expect(court).to be_valid
  end

  it 'should not be valid without the name' do
    court.court_name = ''
    expect(court).not_to be_valid
  end

  it 'should not be valid without the street' do
    court.street = ''
    expect(court).not_to be_valid
  end

  pending 'while we work out why court postcodes are being validated for Scottishness against the dummy database' do
    it 'should not be valid without the postcode' do
      court.postcode = ''
      expect(court).not_to be_valid
    end
  end

  describe '#as_json' do
    let(:json) do
      {
        'name' => 'Good Court',
        'address' => "Good Court\n1 Good Road\nGoodtown\nGT1 2XX"
      }
    end
    it 'should return correct JSON' do
      expect(court.as_json).to eq json
    end
  end

end
