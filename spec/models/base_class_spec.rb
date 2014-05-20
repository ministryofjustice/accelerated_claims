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

    it 'should accept two digit numeric day two digit numeric month' do
      set_date(notice, '31', '01', '2014')
      notice.expiry_date.should == Date.new(2014, 1, 31)
    end

    it "should accept two digit numeric day, month name in lower case: 13 january 2014" do
      set_date(notice, '13', 'january', '2014')
      notice.expiry_date.should == Date.new(2014, 1, 13)
    end

    it 'should accept two digit numeric day, abbreviated month name in lower case:  13 jan 2014' do
      set_date(notice, '13', 'jan', '2014')
      notice.expiry_date.should == Date.new(2014, 1, 13)
    end

    it 'should accept two digit numeric day, abbreviated month name in mixed case:  13 JAn 2014' do
      set_date(notice, '13', 'JAn', '2014')
      notice.expiry_date.should == Date.new(2014, 1, 13)
    end

    it "should accept one digit numeric day, abbreviated month name in mixed case: 1 JAn 2014" do
      set_date(notice, '1', 'JAn', '2014')
      notice.expiry_date.should == Date.new(2014, 1, 1)
    end

    it "should accept one digit day, one digit month: 1 1 2014" do
      set_date(notice, '1', '1', '2014')
      notice.expiry_date.should == Date.new(2014, 1, 1)
    end

    it "should accept 29 Feb 2012 as its a leap year" do
      set_date(notice, '29', 'Feb', '2012')
      notice.expiry_date.should == Date.new(2012, 2, 29)
    end

    it "should not accept 29 02 2014 - which is an invalid day number for Feb" do
      set_date(notice, '29', '02', '2014')
      notice.expiry_date.should be_instance_of(InvalidDate)
    end
    
    it 'should not accept invalid day number for January: 33 01 2014' do
      set_date(notice, '33', '01', '2014')
      notice.expiry_date.should be_instance_of(InvalidDate)
    end

    it 'should not accept invalid day number for april: 31 APRIL 2014'  do
      set_date(notice, '31', 'APRIL', '2014')
      notice.expiry_date.should be_instance_of(InvalidDate)
    end

    it 'should not accept invalid month name:  15-avgust-2014' do 
      set_date(notice, '15', 'avgust', '2014')
      notice.expiry_date.should be_instance_of(InvalidDate)
    end

    it 'should not accept invalid month number: 3-15-2014' do 
      set_date(notice, '3', '15', '2014')
      notice.expiry_date.should be_instance_of(InvalidDate)
    end

    it 'should not accept missing day' do  
      set_date(notice, '', '15', '2014')
      notice.expiry_date.should be_nil
    end

    it 'should not accept missing month' do
      set_date(notice, '3', '', '2014')
      notice.expiry_date.should be_nil
    end

    it 'should not accept missing year' do 
      set_date(notice, '3', '7', '')
      notice.expiry_date.should be_nil
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

