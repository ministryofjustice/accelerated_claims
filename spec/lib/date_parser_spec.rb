require 'spec_helper'

describe DateParser do

  
  context 'invalid values passed in' do
    it 'should raise arg error if values hash doesnt contain parts with expected names' do
      dp = DateParser.new( [ {:part => 'dob(9i)', :value => '34'} ] )
      expect { dp.parse }.to raise_error ArgumentError, 'DateParser expects to find hash with :part name ending (1i), (2i) or (3i)'
    end
  end

  context 'valid date strings' do

    it 'should reject 19th feb in a non leap year' do
      expect(DateParser.new(set_values( ['31', '01', '2014'] )).parse).to eq(Date.new(2014, 1, 31))
    end

    it 'should accept 1 digit day month 2 digit year' do
      expect(DateParser.new(set_values( [ '1', '1', '99' ] )).parse).to eq(Date.new(1999, 1, 1))
    end

    it 'should translate 2-digit year of 49 into 2049' do
      expect(DateParser.new(set_values( [ '1', '3', '49' ] )).parse).to eq(Date.new(2049, 3, 1))
    end

    it 'should accept 3-letter month names' do
      expect(DateParser.new(set_values( [ '13', 'jan', '2014' ] )).parse).to eq(Date.new(2014, 1, 13))
    end

    it 'should accept mixed case month names' do
      expect(DateParser.new(set_values( [ '13', 'JAn', '2014' ] )).parse).to eq(Date.new(2014, 1, 13))
    end

    it 'should accept mixed case month names with 1 digit day' do
      expect(DateParser.new(set_values( [ '1', 'JAn', '2014' ] )).parse).to eq(Date.new(2014, 1, 1))
    end

    it 'should accept 1 digit day and month and 4 digit year' do
      expect(DateParser.new(set_values( [ '1', '1', '2014' ] )).parse).to eq(Date.new(2014, 1, 1))
    end

    it 'should accept 29th Feb in a leap year' do
      expect(DateParser.new(set_values( [ '29', 'Feb', '2012' ] )).parse).to eq(Date.new(2012, 2, 29))
    end

    it 'should accept month names and 2-digit year' do
      expect(DateParser.new(set_values( [ '23', 'march', '14' ] )).parse).to eq(Date.new(2014, 3, 23))
    end

    it 'should accept 2-digit day and 2-digit month' do
      expect(DateParser.new(set_values( [ 23, 5, 2014 ] )).parse).to eq(Date.new(2014, 5, 23))
    end
  end


  context 'invalid dates' do 
    it 'should reject 19th feb in a non leap year' do
      expect(DateParser.new(set_values(['29', '02', '2014'])).parse).to eq(InvalidDate.new('29-02-2014'))
    end

    it 'should reject 33rd in any year' do
      expect(DateParser.new(set_values(['29', '02', '2014'])).parse).to eq(InvalidDate.new('33-01-2014'))
    end

    it 'should reject 31st in a 30-day month' do
      expect(DateParser.new(set_values(['31', 'APRIL', '2014'])).parse).to eq(InvalidDate.new('31-APRIL-2014'))
    end

    it 'should reject unrecognised month names' do
      expect(DateParser.new(set_values(['15', 'avgust', '2014'])).parse).to eq(InvalidDate.new('15-avgust-2014'))
    end

    it 'should reject month numbers > 12' do
      expect(DateParser.new(set_values(['3', '15', '2014'])).parse).to eq(InvalidDate.new('3-15-2014'))
    end

     it 'should reject dates with missing days' do
      expect(DateParser.new(set_values(['', '15', '2014'])).parse).to eq(InvalidDate.new('-01-2014'))
    end

    it 'should reject dates with missing months' do
      expect(DateParser.new(set_values(['3', '', '2014'])).parse).to eq(InvalidDate.new('33--2014'))
    end

    it 'should reject dates with missing year' do
      expect(DateParser.new(set_values(['3', '7', ''])).parse).to eq(InvalidDate.new('3-7-'))
    end
  end




  context 'all blank values' do
    it 'should return nil if all three values are nil' do
      values = set_values( [nil, nil, nil])
      expect(DateParser.new(values).parse).to be_nil
    end

    it 'should return nil if all three values are empty strings' do
      values = set_values( ['', '', ''])
      expect(DateParser.new(values).parse).to be_nil
    end
  end


  context 'translation of 2-digit years to 4-digit years' do

    it 'should translate 68 to 2068 when run in 2014' do
      Timecop.freeze(Date.new(2014, 5, 5)) do
        expect(Date.parse('1-jun-68')).to eq(Date.new(2068, 6, 1))
      end
    end

    it 'should translate 69 to 1969 when run in 2014' do
      Timecop.freeze(Date.new(2014, 5, 5)) do
        expect(Date.parse('1-jun-69')).to eq(Date.new(1969, 6, 1))
      end
    end


    it 'should translate 68 to 2068 when run in 2028' do
      Timecop.freeze(Date.new(2028, 5, 5)) do
        expect(Date.parse('1-jun-68')).to eq(Date.new(2068, 6, 1))
      end
    end


  end



end


def set_values(dmy_array)
  [ {:part => 'dob(1i)', :value => dmy_array[2]}, {:part => 'dob(2i)', :value => dmy_array[1]}, {:part => 'dob(3i)', :value => dmy_array[0]} ]
end

