describe 'ClaimantHelper', :type => :helper  do

  describe 'claimant_header' do
    context 'claimant_id 1' do
      it 'does not display optional' do
        expect(helper.claimant_header 1).to eq "<h3 class='js-claimanttype individual'>Claimant 1</h3>"
      end
    end

    context 'claimant_id 2' do
      it 'displays optional' do
        expect(helper.claimant_header 2).to eq "<h3>Claimant 2 <span class='hint hide js-claimanttype'>(optional)</span></h3>"
      end
    end
  end
end