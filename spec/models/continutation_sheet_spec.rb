describe ContinuationSheet do

  let(:mock_claimant) {
    double Claimant
  }

  let(:mock_defendant) {
    double Defendant
  }


  let(:claimant_3) {
    params = HashWithIndifferentAccess.new(title: 'Mr', full_name: "John Doe", street: "Streety Street\nLondon", postcode: "SW1H9AJ",  claimant_type: 'individual', claimant_num: 3) 
    Claimant.new(params)
  }

  let(:claimant_4) {
    params = HashWithIndifferentAccess.new(title: 'Mrs', full_name: "Jane Doe", street: "Flat 5\nMansion House\nStreety Street\nKensington\nLondon", postcode: "SW1H9AJ",  claimant_type: 'individual', claimant_num: 4) 
    Claimant.new(params)
  }



  describe '#empty?' do
    it 'should respond true if instantiated with two empty arrays' do
      cs = ContinuationSheet.new(Array.new, Array.new)
      expect(cs.empty?).to be true
    end

    it 'should respond false if the first array is not empty' do
      cs = ContinuationSheet.new([mock_claimant], Array.new)
      expect(cs.empty?).to be false
    end

    it 'should respend false if the second array is not empty' do
      cs = ContinuationSheet.new(Array.new, [ mock_defendant] )
      expect(cs.empty?).to be false
    end

    it 'should repsond false if both arrays are not empty' do
       cs = ContinuationSheet.new([mock_claimant], [ mock_defendant] )
      expect(cs.empty?).to be false     
    end
  end



  describe '#any_defendants?' do
    it 'should return true if there are any defendants' do
      cs = ContinuationSheet.new(Array.new, [ mock_defendant] )
      expect(cs.any_defendants?).to be true
    end

    it 'should return flase if there are no defendants' do
      cs = ContinuationSheet.new([mock_claimant], Array.new)
      expect(cs.any_defendants?).to be false
    end
  end


  describe '#any_claimants?' do
    it 'should return true if there are any defendants' do
      cs = ContinuationSheet.new([mock_claimant], Array.new )
      expect(cs.any_claimants?).to be true
    end

    it 'should return flase if there are no defendants' do
      cs = ContinuationSheet.new(Array.new, [ mock_defendant])
      expect(cs.any_claimants?).to be false
    end
  end


  describe '#pages' do
    context 'claimants only' do
      
      it 'should produce a header and just the claimant when only one claimant' do
        cs = ContinuationSheet.new( [claimant_3], Array.new )
        cs.generate

        expect(cs.pages.first['left']).to eq claimant_3_expected_results
        expect(cs.pages.first['right']).to eq ''
      end

      it 'should produce a header and claimants 3 and 4 when two claimants' do
        cs = ContinuationSheet.new( [claimant_3, claimant_4], Array.new )
        cs.generate
        expect(cs.pages.first['left']).to eq claimants_3_and_4_expected_results
      end

      it 'should produce just claimants 3 and 4 and defendants 2 and 3 when intantiated with 2 of each' do
        cs = ContinuationSheet.new( [claimant_3, claimant_4], defendants_array(3) )
        cs.generate
        expect(cs.pages.first['left']).to eq claimants_3_and_4_and_defendants_2_and_3_expected_results
      end

    end
  end


  describe 'format_pages' do
    context "one panel" do
      it 'should generate an array of one page comprising an emtpy right panel' do
        cs = ContinuationSheet.new( [], [] )
        cs.instance_variable_set(:@panels, [ 'panel 1' ] )
        cs.instance_variable_set(:@num_panels, 1)
        cs.send(:format_pages)
        actual = cs.instance_variable_get(:@pages)
        expect(actual).to eq [ {'left' => 'panel 1', 'right' => '' } ]
      end
    end

    context 'two panels' do
      it 'should generate and array of one page comprising a left and right panel' do
        cs = ContinuationSheet.new( [], [] )
        cs.instance_variable_set(:@panels, [ 'panel 1', 'panel 2' ] )
        cs.instance_variable_set(:@num_panels, 2)
        cs.send(:format_pages)
        actual = cs.instance_variable_get(:@pages)
        expect(actual).to eq [ {'left' => 'panel 1', 'right' => 'panel 2' } ]
      end
    end

    context 'five panels' do
      it 'should generate and array of three page ' do
        cs = ContinuationSheet.new( [], [] )
        cs.instance_variable_set(:@panels, [ 'panel 1', 'panel 2', 'panel 3', 'panel 4', 'panel 5' ] )
        cs.instance_variable_set(:@num_panels, 5)
        cs.send(:format_pages)
        actual = cs.instance_variable_get(:@pages)
        expect(actual).to eq [ 
          {'left' => 'panel 1', 'right' => 'panel 2' },
          {'left' => 'panel 3', 'right' => 'panel 4' },
          {'left' => 'panel 5', 'right' => '' }
         ]
      end
    end
  end

end

# call this with the TOTAL number of defendants - this will return an array of defendants 2 to n
def defendants_array(number_of_defendants)
  array = []
  (2 .. number_of_defendants).each do |i|
    array << Defendant.new( { "title" => "Mrs", 
                              "full_name" => "Defendant Number #{i}", 
                              "street" => "#{i} Downing Street\nLondon", 
                              "postcode" => "SW#{i} #{i}LU", 
                              "defendant_num" => i} 
                          ) 
  end
  array
end




def claimant_3_expected_results
  result =<<EOS
Additional Claimants
====================


Claimant 3:
    Mr John Doe
    Streety Street
    London
    SW1H 9AJ


EOS
end



def claimants_3_and_4_expected_results

  claimant_4 =<<EOS
Claimant 4:
    Mrs Jane Doe
    Flat 5
    Mansion House
    Streety Street
    Kensington
    London
    SW1H 9AJ


EOS
  "#{claimant_3_expected_results}#{claimant_4}"
end


def claimants_3_and_4_and_defendants_2_expected_results
  defendant_2 =<<EOS
Additional Defendants
=====================


Defendant 2:
    Mrs Defendant Number 2
    2 Downing Street
    London
    SW2 2LU


EOS
  "#{claimants_3_and_4_expected_results}#{defendant_2}"
end


def claimants_3_and_4_and_defendants_2_and_3_expected_results
  defendant_3 =<<EOS
Defendant 3:
    Mrs Defendant Number 3
    3 Downing Street
    London
    SW3 3LU


EOS
  "#{claimants_3_and_4_and_defendants_2_expected_results}#{defendant_3}"
end





