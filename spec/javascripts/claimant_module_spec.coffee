//= require underscore
//= require jquery
//= require jasmine-jquery
//= require claimant_module

expectSubpanelsVisible = (v1, v2, v3, v4) ->
  if (v1 is true) then expect($("#claimant_1_subpanel")[0]).toBeVisible() else expect($("#claimant_1_subpanel")[0]).toBeHidden()
  if (v2 is true) then expect($("#claimant_2_subpanel")[0]).toBeVisible() else expect($("#claimant_2_subpanel")[0]).toBeHidden()
  if (v3 is true) then expect($("#claimant_3_subpanel")[0]).toBeVisible() else expect($("#claimant_3_subpanel")[0]).toBeHidden()
  if (v4 is true) then expect($("#claimant_4_subpanel")[0]).toBeVisible() else expect($("#claimant_4_subpanel")[0]).toBeHidden()

describe 'ClaimantModule', ->
  element = null

  beforeEach ->
    element = $(
      '<input id="claim_claimant_type_individual" name="claim[claimant_type]" value="individual" type="radio"></input>' +
      '<input id="claim_claimant_type_organization" name="claim[claimant_type]" value="organization" type="radio"></input>' +
      '<input id="claim_num_claimants" name="claim[num_claimants]" type="text"></input>' +
      '<div id="claimant_1_subpanel" class="sub-panel claimant">BBBB</div>' +
      '<div id="claimant_2_subpanel" class="sub-panel claimant same-address">' +
        '<input checked="checked" class="yesno" id="claim_claimant_2_address_same_as_first_claimant_yes" name="claim[claimant_2][address_same_as_first_claimant]" type="radio" value="Yes">' +
        '<input class="yesno" id="claim_claimant_2_address_same_as_first_claimant_no" name="claim[claimant_2][address_same_as_first_claimant]" type="radio" value="No">' +
        '<div class="postcode-selection-els" id="claim_claimant_2_postcode_selection_els" style="display: block;">' +
          '<label class="postcode-picker-label" for="claim_claimant_2_postcode_edit_field">Postcode</label>' +
          '<input class="smalltext postcode-picker-edit-field" id="claim_claimant_2_postcode_edit_field" maxlength="8" name="[postcode]" size="8" type="text">' +
          '<a class="button primary postcode-picker-button" data-country="all" href="#claim_claimant_2_postcode_picker">' +
            ' Find UK address' +
          '</a>' +
        '</div>' +
      '</div>' +
      '<div id="claimant_3_subpanel" class="sub-panel claimant">CCCC</div>' +
      '<div id="claimant_4_subpanel" class="sub-panel claimant">DDDD</div>'
    )
    $(document.body).append(element)
    window.ClaimantModule.setup()
    $('#claim_claimant_type_individual').trigger('click')

  afterEach ->
    element.remove()
    element = null

  describe 'setup', ->
    describe 'when there is no value in num_claimants', ->
      it 'hides all sub-panel claimant sections', ->
        expectSubpanelsVisible(false, false, false, false)

    describe 'when there is the value 2 in num_claimants', ->
      it 'displays the first two claimant sections', ->
        $('#claim_num_claimants').val('2')
        window.ClaimantModule.setup()
        expectSubpanelsVisible(true, true, false, false)

  describe 'showClaimants', ->
    describe 'called with 2', ->
      it 'shows first two claimant sections', ->
        window.ClaimantModule.showClaimants('2')
        expectSubpanelsVisible(true, true, false, false)

    describe 'called with 5', ->
      it 'should unhide the error message', ->
        html = $(
               '<input id="claim_num_claimants" name="claim[num_claimants]" type="text"></input>' +
               '<span class="error hide" id="num-claimants-error-message" style="display: inline;">XXXXX</span>'
        )
        $(document.body).append(html)
        window.ClaimantModule.showClaimants('5')
        errorMessage = $('#num-claimants-error-message')
        expect(errorMessage).toBeVisible()

    describe 'called with 1 after 3', ->
      it 'shows just one claimant', ->
        window.ClaimantModule.showClaimants('3')
        expectSubpanelsVisible(true, true, true, false)

        window.ClaimantModule.showClaimants('1')
        expectSubpanelsVisible(true, false, false, false)

    describe 'with out of range values', ->
      describe 'with zero', ->
        it 'hides all sections', ->
          window.ClaimantModule.showClaimants('0')
          expectSubpanelsVisible(false, false, false, false)

      describe 'with empty string', ->
        it 'hides all sections', ->
          window.ClaimantModule.showClaimants('')
          expectSubpanelsVisible(false, false, false, false)

      describe 'with alpha string', ->
        it 'hides all sections', ->
          window.ClaimantModule.showClaimants('AB')
          expectSubpanelsVisible(false, false, false, false)

  describe 'on number of claimants keyup event', ->
    describe 'with 2 entered', ->
      it 'calls showClaimants with 2', ->
        spyOn window.ClaimantModule, 'showClaimants'
        $('#claim_num_claimants').val('2')
        $('#claim_num_claimants').trigger 'keyup'
        expect(window.ClaimantModule.showClaimants).toHaveBeenCalledWith('2')

  describe 'switching claimant type', ->

    describe 'switching from 2 individuals to organization', ->
      beforeEach =>
        $('#claim_num_claimants').val('2')
        $('#claim_num_claimants').trigger 'keyup'
        $('#claim_claimant_type_organization').trigger('click')

      it 'should only display the first claimant section', ->
        expectSubpanelsVisible(true, false, false, false)

      describe 'and then switching back to individual', ->
        it 'should display the first two claimant section', ->
          $('#claim_claimant_type_individual').trigger('click')
          expectSubpanelsVisible(true, true, false, false)

  describe 'clicking No radio button', ->
    it 'should make the claim_claimant_2_postcode_selection_els element visible', ->
      $('#claim_claimant_2_postcode_selection_els').hide()
      expect($('#claim_claimant_2_postcode_selection_els')).not.toBeVisible()
      $('#claim_claimant_2_address_same_as_first_claimant_no').click()
      expect($('#claim_claimant_2_postcode_selection_els')).toBeVisible()

