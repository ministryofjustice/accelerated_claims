RSpec.describe Court, :type => :model do

  let(:court) do
    Court.new(court_name: 'Good Court',
              address: '1 Good Road',
              town: 'Goodtown',
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

  it 'should not be valid without the address' do
    court.address = ''
    expect(court).not_to be_valid
  end

  it 'should not be valid without the town' do
    court.town = ''
    expect(court).not_to be_valid
  end

  it 'should not be valid without the postcode' do
    court.postcode = ''
    expect(court).not_to be_valid
  end

  describe '#as_json' do
    let(:json) do
      {
        'court_name' => 'Good Court',
        'street' => '1 Good Road, Goodtown',
        'postcode' => 'GT1 2XX'
      }
    end
    it 'should return correct JSON' do
      expect(court.as_json).to eq json
    end
  end

end
