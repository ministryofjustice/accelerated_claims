//= require underscore
//= require jquery
//= require jasmine-jquery
//= require claimant_module

describe 'ClaimantModule', ->
  element = null

  beforeEach ->
    element = $(
      '<input id="claim_num_claimants" name="claim[num_claimants]" type="text">' +
      '<div class="sub-panel claimant" id="claimant_1_subpanel">AAAA</div>' + 
      '<div class="sub-panel claimant" id="claimant_2_subpanel">BBBB</div>' + 
      '<div class="sub-panel claimant" id="claimant_3_subpanel">CCCC</div>' + 
      '<div class="sub-panel claimant" id="claimant_4_subpanel">DDDD</div>')
    $(document.body).append(element)
    window.ClaimantModule.setup()

  afterEach ->
    element.remove()
    element = null

  describe 'setup', ->
    describe 'when there is no value in num_claimants', ->
      it 'hides all sub-panel claimant sections', ->
        window.ClaimantModule.setup()
        expect( $('#claimant_1_subpanel')[0] ).toBeHidden()
        expect( $('#claimant_2_subpanel')[0] ).toBeHidden()
        expect( $('#claimant_3_subpanel')[0] ).toBeHidden()
        expect( $('#claimant_4_subpanel')[0] ).toBeHidden()

    describe 'when there is the value 2 in num_claimants', ->
      it 'displays the first two claimant sections', ->
        $('#claim_num_claimants').val('2')
        window.ClaimantModule.setup()
        expect( $('#claimant_1_subpanel')[0] ).toBeVisible()
        expect( $('#claimant_2_subpanel')[0] ).toBeVisible()
        expect( $('#claimant_3_subpanel')[0] ).toBeHidden()
        expect( $('#claimant_4_subpanel')[0] ).toBeHidden()

  describe 'showClaimants', ->
    beforeEach ->
      window.ClaimantModule.setup()

    describe 'called with 2', ->
      it 'shows first two claimant sections', ->
        window.ClaimantModule.showClaimants('2')
        expect( $('#claimant_1_subpanel')[0] ).toBeVisible()
        expect( $('#claimant_2_subpanel')[0] ).toBeVisible()
        expect( $('#claimant_3_subpanel')[0] ).toBeHidden()
        expect( $('#claimant_4_subpanel')[0] ).toBeHidden()

    describe 'called with 1 after 3', ->
      it 'shows just one claimant', ->
        window.ClaimantModule.showClaimants('3')
        expect( $('#claimant_1_subpanel')[0] ).toBeVisible()
        expect( $('#claimant_2_subpanel')[0] ).toBeVisible()
        expect( $('#claimant_3_subpanel')[0] ).toBeVisible()
        expect( $('#claimant_4_subpanel')[0] ).toBeHidden()

        window.ClaimantModule.showClaimants('1')
        expect( $('#claimant_1_subpanel')[0] ).toBeVisible()
        expect( $('#claimant_2_subpanel')[0] ).toBeHidden()
        expect( $('#claimant_3_subpanel')[0] ).toBeHidden()
        expect( $('#claimant_4_subpanel')[0] ).toBeHidden()

    describe 'with out of range values', ->
      describe 'with zero', ->
        it 'hides all sections', ->
          window.ClaimantModule.showClaimants('0')
          expect( $('#claimant_1_subpanel')[0] ).toBeHidden()
          expect( $('#claimant_2_subpanel')[0] ).toBeHidden()
          expect( $('#claimant_3_subpanel')[0] ).toBeHidden()
          expect( $('#claimant_4_subpanel')[0] ).toBeHidden()

      describe 'with empty string', ->
        it 'hides all sections', ->
          window.ClaimantModule.showClaimants('')
          expect( $('#claimant_1_subpanel')[0] ).toBeHidden()
          expect( $('#claimant_2_subpanel')[0] ).toBeHidden()
          expect( $('#claimant_3_subpanel')[0] ).toBeHidden()
          expect( $('#claimant_4_subpanel')[0] ).toBeHidden()

      describe 'with alpha string', ->
        it 'hides all sections', ->
          window.ClaimantModule.showClaimants('AB')
          expect( $('#claimant_1_subpanel')[0] ).toBeHidden()
          expect( $('#claimant_2_subpanel')[0] ).toBeHidden()
          expect( $('#claimant_3_subpanel')[0] ).toBeHidden()
          expect( $('#claimant_4_subpanel')[0] ).toBeHidden()


  describe 'on number of claimants keyup event', ->
    beforeEach ->
      window.ClaimantModule.setup()

    describe 'with 2 entered', ->
      it 'calls showClaimants with 2', ->
        spyOn window.ClaimantModule, 'showClaimants'
        $('#claim_num_claimants').val('2')
        $('#claim_num_claimants').trigger 'keyup'
        expect(window.ClaimantModule.showClaimants).toHaveBeenCalledWith('2')
