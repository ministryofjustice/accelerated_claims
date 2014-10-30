//= require underscore
//= require jquery
//= require jasmine-jquery
//= require defendant_module


describe "DefendantModule", ->
  element=null
  beforeEach ->
    element= $("""
    <div class="defendant sub-panel" id="defendant_1_subpanel" style="display: block;">
      <div class="row divider"></div>
      <div class="row">
        <h3></h3><h3>Defendant 1</h3>
      </div>
      <div class="row title"><label for="claim_defendant_1_title">Title</label>
      <input class="smalltext" id="claim_defendant_1_title" maxlength="8" name="claim[defendant_1][title]" size="8" type="text"></div>
      <div class="row rel"><label for="claim_defendant_1_full_name">Full name</label>
      <input id="claim_defendant_1_full_name" maxlength="40" name="claim[defendant_1][full_name]" size="40" type="text"></div>
      <div class="sub-panel details" id="defendant_1_resident_address">
        <div class="row js-only">
          <a aria-expanded="false" class="caption js-inhabitproperty show-hide" href="#defendant-1-resident-details" id="defendant_1_resident_details">
            If the defendant is not living in the property, enter the address
          </a>
        </div>
        <div class="row rel street"><label for="claim_defendant_1_street">Full address</label>
        <textarea id="claim_defendant_1_street" maxlength="70" name="claim[defendant_1][street]"></textarea></div>
        <div class="row js-only"><span class="error hide" id="claim_defendant_1_street-error-message">
              The address can’t be longer than 4 lines.
            </span></div>
        <div class="row rel postcode"><label for="claim_defendant_1_postcode">Postcode</label>
        <input class="smalltext" id="claim_defendant_1_postcode" maxlength="8" name="claim[defendant_1][postcode]" size="8" type="text"></div>
      </div>
    </div>

    """)
    $(document.body).append(element)
    @detail = $('#defendant_1_resident_address')
    @link = $('#defendant_1_resident_details')

  afterEach ->
    element.remove()
    element = null

  describe 'initial view', ->
    it 'should not expand address block', ->
      DefendantModule.showDefendants(1)
      expect(@detail).not.toHaveClass('open')
      expect(@detail).toHaveClass('details')

    it 'should show address block after click', ->
      DefendantModule.setup()
      DefendantModule.showDefendants(1)
      $('#defendant_1_resident_details').trigger('click')
      expect(@detail).toHaveClass('open')

    it 'should hide address block after second click', ->
      DefendantModule.setup()
      DefendantModule.showDefendants(1)
      $('#defendant_1_resident_details').trigger('click')
      $('#defendant_1_resident_details').trigger('click')
      expect(@detail).not.toHaveClass('open')
