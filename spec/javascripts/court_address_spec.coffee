//= require underscore
//= require jquery
//= require jasmine-jquery
//= require court_address

enterPostcode = (postcode) ->
  postcode_field = $('#claim_property_postcode')
  postcode_field.val(postcode)

describe 'CourtAddressModule', ->
  element = null

  beforeEach ->
    element = $( '<div id="court-address-label"/>' +
        '<div id="court-name"/>' +
        '<input id="claim_property_postcode" name="claim[property][postcode]" type="text"/>' +
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

  describe 'enable toggling of court address form', ->
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
        enterPostcode('SG8 0LT')
        $('#claim_property_postcode').trigger('change')
        expect(window.CourtLookup.lookup).toHaveBeenCalledWith('SG8 0LT', window.CourtAddressModule)

    describe 'once the court finder lookup happened successfully', ->
      describe 'form behaviour', ->
        court_name = null
        street = null
        postcode = null

        beforeEach ->
          court_name = 'court_name'
          street = 'court_street'
          postcode = 'court_postcode'
          window.CourtAddressModule.populateCourtAddressForm(court_name, street, postcode)

        it 'should populate the court name', ->
          expect($('#claim_court_court_name').val()).toMatch(court_name)

        it 'should populate the court address', ->
          expect($('#claim_court_street').val()).toMatch(street)

        it 'should populate the court postcode', ->
          expect($('#claim_court_postcode').val()).toMatch(postcode)

      describe 'form link for manual court address entry', ->
        beforeEach ->
          window.CourtAddressModule.linkForFormToggling()

        it 'should add the link only once', ->
          window.CourtAddressModule.linkForFormToggling()
          details = $("[id^=court-details]").length
          expect(details).toEqual(1)

      describe 'when street field is visible', ->

        beforeEach ->
          window.CourtAddressModule.enableTogglingOfCourtAddressForm()

        it 'should be a textarea', ->
          $('#court-details').trigger 'click'
          street_field = $('#claim_court_street').prop('tagName').toLowerCase()
          expect(street_field).toEqual('textarea')

    describe 'on form on expansion', ->
        beforeEach ->
          window.CourtAddressModule.populateCourtAddressForm('court_name', 'street', 'postcode')
          window.CourtAddressModule.blankFormFields()

        it 'should blank out the form', ->
          for attr_name in ['court_name', 'street', 'postcode']
            field = $("#claim_court_#{attr_name}").val()
            expect(field).toEqual('')

        it 'should display the address field as text area', ->
          window.CourtAddressModule.changeInputFieldToTextarea()
          field = $('#claim_court_street').prop('tagName').toLowerCase()
          expect(field).toEqual('textarea')

      describe 'form label', ->
        it 'should change the label text', ->
          text = "You need to post this claim to the court nearest \
          the property you're taking back:"
          window.CourtAddressModule.labelForKnownCourt()
          label = $('#court-address-label').html()
          expect(label).toMatch(text)

    describe 'on form hiding', ->
      beforeEach ->
        window.CourtAddressModule.blankFormFields()
        window.CourtAddressModule.flipTextareaToInputField()
        enterPostcode('SG8 0LT')

      it 'should turn textarea to input field', ->
        street_field = $('#claim_court_street').prop('tagName').toLowerCase()
        expect(street_field).toEqual('input')

      it 'should try to re-populate the court address', ->
        spyOn(window.CourtAddressModule, 'lookUpCourt')
        $('#court-details').trigger 'click'
        expect(window.CourtAddressModule.lookUpCourt).toHaveBeenCalled()

    describe 'with no postcode provided', ->
      it 'should not do Court address lookup', ->
        spyOn(window.CourtLookup, 'lookup')
        enterPostcode('')
        expect(window.CourtLookup.lookup).not.toHaveBeenCalled()

      it 'should call displayNoResultsFound', ->
        spyOn(window.CourtAddressModule, 'displayNoResultsFound')
        enterPostcode('')
        $('#claim_property_postcode').trigger('change')
        expect(window.CourtAddressModule.displayNoResultsFound).toHaveBeenCalled()

  describe 'on page load', ->
    it 'should change the textarea into input field', ->
      window.CourtAddressModule.flipTextareaToInputField()
      street = $('#claim_court_street').prop('tagName').toLowerCase()
      expect(street).toMatch('input')

    it 'should add court address form label', ->
      window.CourtAddressModule.addCourtAddressFormLabel()
      label = $('#court-address-label').html()
      html = "You haven't entered a postcode for the property you want to take back.<br> \
        To see the court you need to send this claim to, <a href=\"#property\">enter the postcode now</a>"
      expect(label).toMatch(html)

    it 'should hide the court address form', ->
      window.CourtAddressModule.hideCourtAddress()
      address = $('#court-address')
      expect(address).not.toBeVisible()

    describe 'populate court address if property details are present', ->
      beforeEach ->
        enterPostcode('SG8 0LT')

      describe 'with a postcode provided', ->
        it 'should do court address lookup', ->
          spyOn(window.CourtLookup, 'lookup')
          window.CourtAddressModule.getCourtIfPostcodePresent()
          expect(window.CourtLookup.lookup).toHaveBeenCalledWith('SG8 0LT', window.CourtAddressModule)

        it 'should not do court address lookup', ->
          name = $('#claim_court_court_name').val('Some court')
          spyOn(window.CourtLookup, 'lookup')
          window.CourtAddressModule.getCourtIfPostcodePresent()
          expect(window.CourtLookup.lookup).not.toHaveBeenCalledWith('SG8 0LT', window.CourtAddressModule)
