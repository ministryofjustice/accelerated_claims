describe PostcodeLookupProxy do

  describe '.new' do
    context 'a valid postcode' do
      it 'should return be valid' do
        pc = PostcodeLookupProxy.new('WC1B5HA')
        expect(pc).to be_valid
      end
    end

    context 'invalid postcode' do
      it 'should not be valid' do
        pc = PostcodeLookupProxy.new('WCX1B5HA')
        expect(pc).not_to be_valid
      end
    end
  end


  describe '#lookup' do
    it 'should return bad request if invalid postcode' do
      pc = PostcodeLookupProxy.new('WCX1B5HA')
      expect(pc.lookup).to eq :bad_request
    end

    it 'should call development lookup if not production' do
      pc = PostcodeLookupProxy.new('WC1B5HA')
      expect(pc).to receive(:development_lookup)
      pc.lookup
    end

    it 'should call production lookup if production environment' do
      pc = PostcodeLookupProxy.new('WC1B5HA')
      expect(Rails.env).to receive(:production?).and_return(true)
      expect(pc).to receive(:production_lookup)
      pc.lookup
    end
  end


  describe 'private method production_lookup' do
    it 'should raise an error' do
      expect {
        PostcodeLookupProxy.new("WC1B5HA").send(:production_lookup)
      }.to raise_error NotImplementedError, "Postcode lookup not yet implemented"
    end


    describe 'private method development_lookup' do
      it 'should return and empty array if the first digit of the 2nd part of the postcode is zero' do
        pc = PostcodeLookupProxy.new('SW150HG')
        expect(pc.send(:development_lookup)).to eq []
      end


      it 'should return the 2nd element of the dummy postcode results with a first digit of 2nd part of postcode is 1' do
        pc = PostcodeLookupProxy.new('BR31ES')
        expect(pc.send(:development_lookup)).to eq PostcodeLookupProxy.class_variable_get(:@@dummy_postcode_results)[1]
      end
    end
  end
end