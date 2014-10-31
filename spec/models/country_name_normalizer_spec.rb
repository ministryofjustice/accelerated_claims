describe CountryNameNormalizer do

  describe '#normalize' do

    it 'should return emtpy array for params wihout vc key' do
      params = HashWithIndifferentAccess.new( {pc: 'sw1h 1hh'})
      cnn = CountryNameNormalizer.new(params)
      expect(cnn.normalize).to eq []
    end


    it 'should return england and wales for england wales' do
      params = HashWithIndifferentAccess.new( {pc: 'sw1h 1hh', vc: 'england wales'})
      cnn = CountryNameNormalizer.new(params)
      expect(cnn.normalize).to eq ['England', 'Wales']
    end

    it 'should normalize country names with more than one word' do
      params = HashWithIndifferentAccess.new( {pc: 'sw1h 1hh', vc: 'england wales isle_of_man northern_ireland channel_islands'})
      cnn = CountryNameNormalizer.new(params)
      expect(cnn.normalize).to eq ['England', 'Wales', 'Isle of Man', 'Northern Ireland', 'Channel Islands']
    end
   end


end