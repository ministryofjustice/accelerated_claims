
describe 'Address', :type => :model do

  let(:address)  do
      property = Property.new(street: 'my street', age: 20, house: 'yes', postcode: 'sw109lb')
      address = Address.new(property)
    end

  describe '.new' do

    it 'should extract street and postcode params from a bigger set of params' do
      expect(address.street).to eq 'my street'
      expect(address.postcode).to eq 'sw109lb'
    end

    it 'should set must be blank to false by default' do
      expect(address.must_be_blank).to be false
    end

    it 'should set england and wales only to false by default' do
      expect(address.england_and_wales_only).to be false
    end
  end

  describe '#subject_description' do

    it 'should take the subject description from the parent objects class' do
      allow(address.instance_variable_get(:@parent)).to receive(:subject_description).and_return('my property')
      expect(address.subject_description).to eq 'my property'
    end

    it 'should pick up the class name if the parent object does not repond to subject description' do
      allow(address.instance_variable_get(:@parent)).to receive(:respond_to?).and_return(false)
      expect(address.subject_description).to eq 'Property'
    end
  end


  describe '#possessive_subject_description' do
    it 'should take the subject description from the parent objects class' do
      allow(address.instance_variable_get(:@parent)).to receive(:possessive_subject_description).and_return("The Property's")
      expect(address.possessive_subject_description).to eq "The Property's"
    end


    it 'should pick up the class name if the parent object does not repond to subject description' do
      allow(address.instance_variable_get(:@parent)).to receive(:respond_to?).and_return(false)
      expect(address.possessive_subject_description).to eq "Property's"
    end
  end


  context 'validation' do
    
    context 'with must be blank false' do
      
      context 'postcode validation' do
        
        context 'with engand_and_wales only set to true' do

          it 'should pass validation on an valid uk postcode' do
            address.england_and_wales_only!
            expect(address).to be_valid
          end

          it 'should reject scottish postcodes if england and wales only set' do
            address = Address.new(Property.new(street: 'my scottish street', postcode: 'ab255xh'))
            address.england_and_wales_only!
            expect(address).not_to be_valid
            expect(address.errors[:postcode]).to eq ["Postcode is in Scotland. You can only use this service to regain possession of properties in England and Wales."]
          end

          it 'should reject missing postcodes' do
            address = Address.new(Property.new(street: 'my scottish street'))
            address.england_and_wales_only!
            expect(address).not_to be_valid
            expect(address.errors[:postcode]).to eq ["Please enter a valid postcode for a property in England and Wales"]
          end
        end

        context 'england and wales only not set' do
          it 'should not reject scottish postcodes if england and wales only set' do
            address = Address.new(Property.new(street: 'my scottish street', postcode: 'ab255xh'))
            expect(address).to be_valid
          end

          it 'should accept missing postcodes if england and wales only not set' do
            address = Address.new(Property.new(street: 'my scottish street'))
            expect(address).to be_valid
          end

          it 'should accept foreign postcodes if england and wales only not set' do
            address = Address.new(Property.new(street: 'my scottish street', postcode: '90100'))
            expect(address).to be_valid
          end
        end
      end

      context 'street validation' do
        it 'should reject missing street' do
          address = Address.new(Property.new(postcode: '90100'))
          expect(address).not_to be_valid
          expect(address.errors[:street]).to eq ["Enter property full address"]
        end

        it 'should reject blank street' do
          address = Address.new(Property.new(street: '', postcode: '90100'))
          expect(address).not_to be_valid
          expect(address.errors[:street]).to eq ["Enter property full address"]
        end
        
        it 'should reject nil street' do
          address = Address.new(Property.new(street: nil, postcode: '90100'))
          expect(address).not_to be_valid
          expect(address.errors[:street]).to eq ["Enter property full address"]
        end
      end
    end

    context 'with must_be_blank true' do
      it 'should accept blank street and postcode' do
        address = Address.new(Property.new( {house: 'Yes'} ))
        address.must_be_blank!
        expect(address).to be_valid
      end
      
      it 'should reject street present' do
        address = Address.new(Property.new( {house: 'Yes', street: 'my street'} ))
        address.must_be_blank!
        expect(address).not_to be_valid
        expect(address.errors[:street]).to eq ["Address for property must be blank"]
      end

      it 'should reject postcoce present' do
        address = Address.new(Property.new( {house: 'Yes', postcode: 'RG2 7PU'} ))
        address.must_be_blank!
        expect(address).not_to be_valid
        expect(address.errors[:postcode]).to eq ["Postcode for property must be blank"]
      end

    end
  end

  describe '#transfer_error_messages_to_parent' do
    it 'should transfer errors from address object to parent object' do
      address.errors[:street] << "Street error 1"
      address.errors[:street] << "Street error 2"
      address.errors[:postcode] << "postcode error"
      address.send(:transfer_error_messages_to_parent)
      parent_errors = address.instance_variable_get(:@parent).errors
      expect(parent_errors[:street]).to eq ["Street error 1", "Street error 2"]
      expect(parent_errors[:postcode]).to eq ["postcode error"]
    end
  end

  describe '#==' do
    it 'should be equal if the street and postcode are the same' do
      a1 = Address.new(Property.new(street: 'my street', postcode: 'sw109lb', house: 'Yes'))
      a2 = Address.new(Property.new(street: 'my street', postcode: 'sw109lb', house: 'No'))
      expect(a1 == a2).to be true
    end

    it 'should not be equal if the attrs are diffferent' do
      a1 = Address.new(Property.new(street: 'my streetxx', postcode: 'sw109lb', house: 'Yes'))
      a2 = Address.new(Property.new(street: 'my street', postcode: 'sw109lb', house: 'No'))
      expect(a1 == a2).to be false
    end
  end

  describe 'suppress_validation' do
    it 'should clear all errrors and return true to valid' do
      address = Address.new(Property.new( {house: 'Yes', postcode: 'RG2XXX7PU'} ))
      expect(address).to_not be_valid
      expect(address.errors[:street]).to eq ['Enter property full address']
      
      address.suppress_validation!
      expect(address).to be_valid
      expect(address.errors).to be_empty
    end


  end

end



def hwi(hash)
  HashWithIndifferentAccess.new(hash)
end