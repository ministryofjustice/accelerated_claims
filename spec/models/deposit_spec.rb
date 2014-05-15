describe Deposit do

  describe "when the deposit has not been received" do
    context "and information given date is populated" do
      let(:deposit) { Deposit.new(received: 'No',
                                  information_given_date: Date.parse("2010-01-10")) }
      let(:error) { ["can't be provided if there is no deposit given"] }

      it { should_not be_valid }

      it "should have an error message" do
        deposit.valid?
        expect(deposit.errors[:information_given_date]).to eq error
      end
    end

    context "and reference number is populated" do
      let(:deposit) { Deposit.new(received: 'No',
                                  ref_number: 'x123') }
      let(:error) { ["can't be provided if there is no deposit given"] }

      it { should_not be_valid }

      it "should have an error message" do
        deposit.valid?
        expect(deposit.errors[:ref_number]).to eq error
      end
    end
  end

  context "when the deposit has been received" do
    let(:deposit) { Deposit.new(received: 'Yes',
                                ref_number: 'x123',
                                as_property: 'No',
                                as_money: 'Yes',
                                information_given_date: Date.parse("2010-01-10")) }

   

    describe "when given all valid values" do
      it "should be valid" do
        deposit.should be_valid
      end
    end

    describe "when money deposit value is blank" do
      it "shouldn't be valid" do
        deposit.received = ""
        deposit.should_not be_valid
      end
    end

    describe "when deposit's property is blank" do
      it "shouldn't be valid" do
        deposit.as_property = ""
        deposit.should_not be_valid
      end
    end

    describe 'as_json' do
      it 'should return correct json' do
        deposit.as_json.should == {
          "as_property" => "No",
          "as_money" => "Yes",
          "information_given_date_day"=>"10",
          "information_given_date_month"=>"01",
          "information_given_date_year"=>"2010",
          "received" => "Yes",
          "ref_number" => 'x123'
        }
      end
    end
  end

  context 'validation of type of deposit' do
    it 'should not validate if neither property nor money selected' do
      deposit = Deposit.new(received: 'Yes',
                            ref_number: 'x123',
                            as_property: 'No',
                            as_money: 'No',
                            information_given_date: Date.parse("2010-01-10")) 
      deposit.should_not be_valid
      deposit.errors[:as_money].should == ["or As Property must be selected as the type of deposit"]
    end

    it 'should validate if both money and property are selected' do
      deposit = Deposit.new(received: 'Yes',
                            ref_number: 'x123',
                            as_property: 'Yes',
                            as_money: 'Yes',
                            information_given_date: Date.parse("2010-01-10")) 
      deposit.should be_valid
    end
  end
    
end
