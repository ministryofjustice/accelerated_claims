//= require underscore
//= require jquery
//= require jasmine-jquery
//= require court_address

describe 'CourtAddressModule', ->
  element = null

  beforeEach ->
    element = $('<div style="display: block;" id="court-address">' +
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

