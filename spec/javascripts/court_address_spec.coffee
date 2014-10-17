//= require underscore
//= require jquery
//= require jasmine-jquery
//= require court_address

describe 'CourtAddressModule', ->
  element = null

  beforeEach ->
    element = $('<input id="claim_property_postcode" name="claim[property][postcode]" type="text"/>' +
        '<div style="display: block;" id="court-address">' +
        '<div class="row"><label for="claim_court_court_name">Name of court</label>' +
        '<input id="claim_court_court_name" name="claim[court][court_name]" type="hidden"></div>' +
        '<div class="row"><label for="claim_court_street">Full address</label>' +
        '<textarea id="claim_court_street" name="claim[court][street]"></textarea></div>' +
        '<div class="row"><label for="claim_court_postcode">Postcode</label>' +
        '<input id="claim_court_postcode" name="claim[court][postcode]" type="hidden"></div>' +
      '</div>')
    $(document.body).append(element)

  afterEach ->
    element.remove()
    element = null

  describe 'hideCourtAddress', ->
    it 'hides the court address', ->
      window.CourtAddressModule.hideCourtAddress()
      address = $('#court-address')
      expect(address).not.toBeVisible()

  describe 'enableTogglingOfCourtAddressForm', ->
    link = null

    beforeEach ->
      link = $('<a id="court-details" class="caption" href="#court-details">Choose to send this claim to a different court</a>')
      $(document.body).append(link)

    afterEach ->
      link.remove()
      link = null

    it 'should toggle the court address form', ->
      address = $('#court-address')
      window.CourtAddressModule.enableTogglingOfCourtAddressForm()
      $('#court-details').trigger 'click'
      expect(address).not.toBeVisible()

  describe 'changing the postcode of the property value', ->

    beforeEach ->
      window.CourtAddressModule.sendPostcodeForLookup()

    describe 'with a postcode provided', ->
      it 'should do Court address lookup', ->
        spyOn(window.CourtLookup, 'lookup')
        postcode = 'SG8 0LT'
        postcode_field = $('#claim_property_postcode')
        postcode_field.val(postcode)
        postcode_field.focusout()
        expect(window.CourtLookup.lookup).toHaveBeenCalledWith(postcode, window.CourtAddressModule)

    describe 'with no postcode provided', ->
      it 'should not do Court address lookup', ->
        spyOn(window.CourtLookup, 'lookup')
        postcode = ''
        postcode_field = $('#claim_property_postcode')
        postcode_field.val(postcode)
        postcode_field.focusout()
        expect(window.CourtLookup.lookup).not.toHaveBeenCalled()

      it 'should call displayNoResultsFound', ->
        spyOn(window.CourtAddressModule, 'displayNoResultsFound')
        postcode = ''
        postcode_field = $('#claim_property_postcode')
        postcode_field.val(postcode)
        postcode_field.focusout()
        expect(window.CourtAddressModule.displayNoResultsFound).toHaveBeenCalled()
