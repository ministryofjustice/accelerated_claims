describe Deposit, :type => :model do

  describe "when the deposit has not been received" do

    context "and reference number and information_given_date is populated" do
      let(:deposit) { Deposit.new(received: 'No',
                                  information_given_date: Date.parse("2010-01-10"),
                                  ref_number: 'x123') }

      it { is_expected.not_to be_valid }

      it "should have an error message for ref_number and information_given_date" do
        deposit.valid?
        expect(deposit.errors[:ref_number]).to eq( [ "You should not give a deposit scheme reference number if no deposit was given" ] )
        expect(deposit.errors[:information_given_date]).to eq( [ "You should not give an information given date if no deposit was given" ] )
      end
    end
  end

  context "when the deposit has been received" do
    let(:deposit) { Deposit.new(received: 'Yes',
                                ref_number: 'x123',
                                information_given_date: Date.parse("2010-01-10"),
                                as_property: 'No',
                                as_money: 'Yes') }



    context 'as money' do
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

      describe 'when deposit received and date is invalid' do
        it 'shouldnt be valid' do
          deposit.received = "Yes"
          deposit.as_money = "Yes"
          deposit.information_given_date = InvalidDate.new('-7-2011')
          expect(deposit).not_to be_valid
          expect(deposit.errors[:information_given_date]).to eq ["Enter a valid date you gave the defendant this information"]
        end
      end

      describe "when deposit as property is blank and deposit as money is yes" do
        it "should be valid" do
          deposit.as_property = ""
          deposit.received = "Yes"
          expect(deposit).to be_valid
        end
      end

      it "shouldn't be valid if ref_number is blank" do
        deposit.ref_number = ""
        expect(deposit).not_to be_valid
      end

      it "shouldn't be valid if information_given_date is blank" do
        deposit.information_given_date = ""
        expect(deposit).not_to be_valid
      end
    end

    context 'only as property' do
      before do
        deposit.as_property = 'Yes'
        deposit.as_money = 'No'
      end

      it 'should not be valid' do
        expect(deposit).not_to be_valid
      end

      it 'should have an error message' do
        deposit.valid?
        expect(deposit.errors[:ref_number]).to eq(["You should not give a deposit scheme reference number if the deposit was given as property"])
        expect(deposit.errors[:information_given_date]).to eq(["You should not give an information given date if the deposit was given as property"])
      end
    end

    describe 'as_json' do
      context 'when no deposit is received' do
        it 'should return correct json' do
          expect(deposit.as_json).to eq({
            "as_property" => "No",
            "as_money" => "Yes",
            "received" => "Yes",
            "received_cert" => "Yes",
            "information_given_date_day" => "10",
            "information_given_date_month" => "01",
            "information_given_date_year" => "2010",
            "ref_number" => 'x123'
          })
        end
      end
    end

    context 'when no deposit is received' do
      it 'should not have received_cert' do
        deposit.received = 'No'
        expect(deposit.as_json).to eq({
          "as_property" => "No",
          "as_money" => "Yes",
          "received" => "No",
          "received_cert" => "",
          "information_given_date_day" => "10",
          "information_given_date_month" => "01",
          "information_given_date_year" => "2010",
          "ref_number" => 'x123'
        })
      end
    end
  end

  context 'validation of type of deposit' do
    it 'should not validate if neither property nor money selected' do
      deposit = Deposit.new(received: 'Yes',
                            ref_number: 'x123',
                            information_given_date: Date.parse("2010-01-10"),
                            as_property: 'No',
                            as_money: 'No')
      expect(deposit).not_to be_valid
      expect(deposit.errors[:as_money]).to eq(['You must say what kind of deposit the defendant paid'])
    end

    it 'should validate if both money and property are selected' do
      deposit = Deposit.new(received: 'Yes',
                            ref_number: 'x123',
                            information_given_date: Date.parse("2010-01-10"),
                            as_property: 'Yes',
                            as_money: 'Yes')
      expect(deposit).to be_valid
    end
  end

  context 'catching errors during as_json' do
    it 'should catch undefined method strftime errors and add extra information' do
      deposit = Deposit.new(:information_given_date => InvalidDate.new('kjkdjf-dkfdkfj-dfdf'))
      expect {
        deposit.as_json
      }.to raise_error RuntimeError, /undefined method strftime while converting deposit to JSON/
    end
  end

end
