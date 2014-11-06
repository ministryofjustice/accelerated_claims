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

   describe '#to_sentence' do
    it 'should transform england+wales to England and Wales' do
      params = HashWithIndifferentAccess.new( {pc: 'sw1h 1hh', vc: 'england wales'})
      cnn = CountryNameNormalizer.new(params)
      expect(cnn.to_sentence).to eq 'England and Wales'
    end

    it 'should transform england wales isle_of_man northern_ireland channel_islands to England, Wales, Isle of Man and Channel Islands' do
      params = HashWithIndifferentAccess.new( {pc: 'sw1h 1hh', vc: 'england wales isle_of_man northern_ireland channel_islands'})
      cnn = CountryNameNormalizer.new(params)
      expect(cnn.to_sentence).to eq 'England, Wales, Isle of Man, Northern Ireland and Channel Islands'
    end

    it 'should return UK if no country params' do
      params = HashWithIndifferentAccess.new( {pc: 'sw1h 1hh'})
      cnn = CountryNameNormalizer.new(params)
      expect(cnn.to_sentence).to eq 'UK'
    end
   end


end