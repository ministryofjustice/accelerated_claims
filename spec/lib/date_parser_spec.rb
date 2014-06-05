require_relative '../spec_helper'
require_relative '../../app/lib/date_parser'


describe DateParser do

  
  context 'invalid values passed in' do
    it 'should raise arg error if values hash doesnt contain parts with expected names' do
      dp = DateParser.new( [ {:part => 'dob(9i)', :value => '34'} ] )
      expect { dp.parse }.to raise_error ArgumentError, 'DateParser expects to find hash with :part name ending (1i), (2i) or (3i)'
    end
  end

  context 'valid date strings' do

    it 'should create valid dates from the entered values' do

      test_values = {
        ['31', '01', '2014']      => Date.new(2014, 1, 31),
        ['1', '1', '99']          => Date.new(1999, 1, 1),
        ['1', '3', '49']          => Date.new(2049, 3, 1),
        ['13', 'jan', '2014']     => Date.new(2014, 1, 13),
        ['13', 'jan', '2014']     => Date.new(2014, 1, 13),
        ['13', 'JAn', '2014']     => Date.new(2014, 1, 13),
        ['1', 'JAn', '2014']      => Date.new(2014, 1, 1),
        ['1', '1', '2014']        => Date.new(2014, 1, 1),
        ['29', 'Feb', '2012']     => Date.new(2012, 2, 29),
        ['23', 'march', '14']     => Date.new(2014, 3, 23),
        [23, 5, 2014]             => Date.new(2014, 5, 23)
      }

      test_values.each do |dmy, expected_date|
        values = set_values(dmy)
        DateParser.new(values).parse.should == expected_date
      end
    end
  end


  context 'invalid dates' do 
    it 'should create InvalidDate objects from the following invalid strings' do
      test_values = {
        ['29', '02', '2014']     => InvalidDate.new('29-02-2014'),
        ['33', '01', '2014']     => InvalidDate.new('33-01-2014'),
        ['31', 'APRIL', '2014']  => InvalidDate.new('31-APRIL-2014'),
        ['15', 'avgust', '2014'] => InvalidDate.new('15-avgust-2014'),
        ['3', '15', '2014']      => InvalidDate.new('3-15-2014'),
        ['', '15', '2014']       => InvalidDate.new('-01-2014'),
        ['3', '', '2014']        => InvalidDate.new('33--2014'),
        ['3', '7', '']           => InvalidDate.new('33-7-')
      }

      test_values.each do |dmy, expected_date|
        values = set_values(dmy)
        DateParser.new(values).parse.should == expected_date
      end
    end
  end

  context 'all blank values' do
    it 'should return nil if all three values are nil' do
      values = set_values( [nil, nil, nil])
      DateParser.new(values).parse.should be_nil
    end

    it 'should return nil if all three values are empty strings' do
      values = set_values( ['', '', ''])
      DateParser.new(values).parse.should be_nil
    end
  end
end


def set_values(dmy_array)
  [ {:part => 'dob(1i)', :value => dmy_array[2]}, {:part => 'dob(2i)', :value => dmy_array[1]}, {:part => 'dob(3i)', :value => dmy_array[0]} ]
end








 #    it 'should not accept a date before 01 Jan 1989' do
 #      set_date(notice, '3', '7', '1988')
 #      notice.valid?
 #      notice.errors[:expiry_date].first.should == 'Incorrect date: you can only use this form with an assured shorthold tenancy (introduced 15 January 1989)'
 #    end

 #    it 'should not accept a date after today' do
 #      date = 2.days.from_now
 #      set_date(notice, date.day.to_s, date.month.to_s, date.year.to_s)
 #      notice.valid?
 #      notice.errors[:expiry_date].first.should == 'cannot be later than current date'
 #    end