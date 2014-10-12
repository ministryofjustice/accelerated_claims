//= require underscore
//= require jquery
//= require jasmine-jquery
//= require court_address

describe 'CourtAddressModule', ->

  describe 'hideCourtAddressInitially', ->
    it 'should not show the court address form on load', ->
      window.CourtAddressModule.hideCourtAddressInitially()
      element = $('#court-address')
      expect(element).not.toBeVisible()

  describe 'toggleCourtAddressForm', ->
    it 'should toggle the court address form', ->
      window.CourtAddressModule.toggleCourtAddressForm()
      $('#court-details').trigger 'click'
      # TODO: address this
      # expect('#claim_court_court_name').toBeVisible()

  describe 'findCourtName', ->
    it 'should return JSON data', ->
      window.CourtAddressModule.findCourtName('SG8 0LT')
      # TODO: expect ?

  describe 'sendPostcodeForLookup': ->
    it 'should send the postcode provided to be used for court lookup', ->
