describe Property do
  let(:bc) { BaseClass.new }

  it "should respond to #attributes" do
    bc.should respond_to(:attributes)
  end

  it "should respond to #as_json" do
    bc.should respond_to(:as_json)
  end



  context 'set_date' do
    let(:notice)  {Notice.new}

   
    it 'should not accept a date before 01 Jan 1989' do
      set_date(notice, '3', '7', '1988')
      notice.valid?
      notice.errors[:expiry_date].first.should == 'Incorrect date: you can only use this form with an assured shorthold tenancy (introduced 15 January 1989)'
    end

    it 'should not accept a date after today' do
      date = 2.days.from_now
      set_date(notice, date.day.to_s, date.month.to_s, date.year.to_s)
      notice.valid?
      notice.errors[:expiry_date].first.should == 'cannot be later than current date'
    end
  
  end
end


private

def set_date(object, day, month, year)
  object.send(:set_date, 
              "expiry_date", 
              [  {:part => "expiry_date(3i)", :value => day}, 
                 {:part => "expiry_date(2i)", :value => month}, 
                 {:part => "expiry_date(1i)", :value => year}
              ])

end

