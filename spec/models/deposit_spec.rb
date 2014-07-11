describe Deposit, :type => :model do

  describe "when the deposit has not been received" do
    
    context "and reference number is populated" do
      let(:deposit) { Deposit.new(received: 'No',
                                  ref_number: 'x123') }

      it { is_expected.not_to be_valid }

      it "should have an error message" do
        deposit.valid?
        expect(deposit.errors[:ref_number]).to eq( [ "You should not give a deposit scheme reference number if no deposit was given" ] )
      end
    end
  end

  context "when the deposit has been received" do
    let(:deposit) { Deposit.new(received: 'Yes',
                                ref_number: 'x123',
                                as_property: 'No',
                                as_money: 'Yes') }

   

    describe "when given all valid values" do
      it "should be valid" do
        expect(deposit).to be_valid
      end
    end

    describe "when deposit received is blank" do
      it "shouldn't be valid" do
        deposit.received = ""
        expect(deposit).not_to be_valid
        expect(deposit.errors[:received]).to eq ["You must say whether the defendant paid a deposit"]
      end
    end

    describe "when deposit as property is blank and deposit as money is yes" do
      it "should be valid" do
        deposit.as_property = ""
        deposit.as_money = "Yes"
        deposit.received = "Yes"
        expect(deposit).to be_valid
      end
    end

    describe 'when deposit as money is given' do
      it "shouldn't be valid if ref_number is blank" do
        deposit.ref_number = ""
        expect(deposit).not_to be_valid
      end
    end

    describe 'when the deposit has been given' do
      context 'but only as property' do
        before do
          deposit.as_property = 'Yes'
          deposit.as_money = 'No'
        end

        it 'should not be valid' do
          expect(deposit).not_to be_valid
        end

        it 'should have an error message' do
          deposit.valid?
          expect(deposit.errors[:ref_number]).to eq(["You should not give a deposti scheme reference number if the deposit was given as property"])
        end
      end
    end

    describe 'as_json' do
      it 'should return correct json' do
        expect(deposit.as_json).to eq({
          "as_property" => "No",
          "as_money" => "Yes",
          "received" => "Yes",
          "ref_number" => 'x123'
        })
      end
    end
  end

  context 'validation of type of deposit' do
    it 'should not validate if neither property nor money selected' do
      deposit = Deposit.new(received: 'Yes',
                            ref_number: 'x123',
                            as_property: 'No',
                            as_money: 'No')
      expect(deposit).not_to be_valid
      expect(deposit.errors[:as_money]).to eq(['You must say what kind of deposit the defendant paid'])
    end

    it 'should validate if both money and property are selected' do
      deposit = Deposit.new(received: 'Yes',
                            ref_number: 'x123',
                            as_property: 'Yes',
                            as_money: 'Yes') 
      expect(deposit).to be_valid
    end
  end
    
end
