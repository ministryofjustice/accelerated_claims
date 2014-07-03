describe Contact, :type => :model do

  let(:contact) do
    Contact.new(data)
  end

  describe '.name' do
    context 'with a blank name' do
      let(:data) do
        {
          name: '',
          phone: '1234',
          description: 'Give me more'
        }
      end

      it 'should not be valid without a name' do
        expect(contact).not_to be_valid
      end
    end

    context 'with all fields filled in correctly' do
      let(:data) do
        {
          name: 'Ninja Slick',
          phone: '1234',
          description: 'I need things'
        }
      end

      it 'should be valid with a name' do
        expect(contact).to be_valid
      end
    end
  end

  describe '.phone' do
    context 'with a blank phone number' do
      let(:data) { { name: 'Bob', phone: ''} }

      it 'should not be valid without a name' do
        expect(contact).not_to be_valid
      end
    end

    context 'with all fields filled in correctly' do
      let(:data) do
        {
          name: 'Ninja Slick',
          phone: '1234',
          description: 'I need things'
        }
      end

      it 'should be valid with a name' do
        expect(contact).to be_valid
      end
    end
  end

  describe '.describe' do
    context 'with a blank description' do
      let(:data) do
        {
          name: 'Ninja Slick',
          phone: '1234',
          description: ''
        }
      end

      it 'should not be valid without a description' do
        expect(contact).not_to be_valid
      end
    end

    context 'with all fields filled in correctly' do
      let(:data) do
        {
          name: 'Ninja Slick',
          phone: '1234',
          description: 'Show me things'
        }
      end

      it 'should not be valid without a description' do
        expect(contact).to be_valid
      end
    end
  end
end
