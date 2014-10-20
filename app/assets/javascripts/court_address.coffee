root = exports ? this

CourtAddressModule =

  addCourtAddressFormLabel: ->
    label = "You haven't entered a postcode for the property you want to take back.<br> To see the court you need to send this claim to, <a href=\"#property\">enter the postcode now</a>"
    $('#court-address-label').html(label)

  flipTextareaToInputField: ->
    if $('#claim_court_street').is("textarea")
      text_area = $('#claim_court_street')
      input_element = $("<input type='hidden'></input>")
      input_element.attr({ 'name': "#{text_area.attr('name')}" })
      input_element.val("#{text_area.val()}")
      id = "#{text_area.attr('id')}"
      input_element.insertBefore(text_area)
      text_area.remove()
      input_element.attr({ 'id': "#{id}" })

  hideCourtAddress: ->
    $('#claim_court_court_name').attr({ 'type': 'hidden' })
    $('#claim_court_postcode').attr({ 'type': 'hidden' })
    $("#court-address").hide()

  flipVisibilityOfCourtAddressForm: ->
    for attr_name in ['court_name', 'street', 'postcode']
      form_field = "#claim_court_#{attr_name}"
      $(form_field).val('') if $(form_field).not(':visible')
      $(form_field).attr({ 'type': 'text' })

  enableTogglingOfCourtAddressForm: ->
    $("#court-details").click ->
      CourtAddressModule.flipVisibilityOfCourtAddressForm()
      $("#court-address").toggle()

  showCourtAddressForm: ->
    CourtAddressModule.flipVisibilityOfCourtAddressForm()
    $("#court-address").show()

  findCourtName: (postcode) ->
    CourtLookup.lookup(postcode, CourtAddressModule)

  populateCourtDetails: (data) ->
    court_name = data[0].name
    court_street = data[0].address.address_lines
    court_postcode = data[0].address.postcode
    court_name_element = $('#court-name')[0]
    court_name_element.innerHTML = "<b>#{court_name}</b>"
    CourtAddressModule.populateCourtAddressForm(court_name, court_street, court_postcode)
    CourtAddressModule.linkForFormToggling()
    CourtAddressModule.enableTogglingOfCourtAddressForm()
    CourtAddressModule.labelForKnownCourt()

  labelForKnownCourt: ->
    label = "You need to post this claim to the court nearest to \
    the property you're taking back:"
    $('#court-address-label').html(label)

  displayNoResultsFound: ->
    CourtAddressModule.addOriginalFormLabelText()
    CourtAddressModule.showCourtAddressForm()

  addOriginalFormLabelText: ->
    label = 'Enter the name and address of the court you want to send this claim to.'
    $('#court-address-label').text(label)

  populateCourtAddressForm: (court_name, court_street, court_postcode) ->
    $('#claim_court_court_name').val(court_name)
    $('#claim_court_street').val(court_street)
    $('#claim_court_postcode').val(court_postcode)

  linkForFormToggling: ->
    link = "<p/><a id='court-details' class='caption' href='#court-details'>Choose to send this claim to a different court</a>"
    $(link).insertBefore('#court-name')

  sendPostcodeForLookup: ->
    $('#claim_property_postcode').bind 'focusout', ->
      postcode = $('#claim_property_postcode').val()
      if postcode
        CourtAddressModule.findCourtName postcode
      else
        CourtAddressModule.displayNoResultsFound()

  setup: ->
    CourtAddressModule.addCourtAddressFormLabel()
    CourtAddressModule.hideCourtAddress()
    CourtAddressModule.sendPostcodeForLookup()
    CourtAddressModule.enableTogglingOfCourtAddressForm()
    CourtAddressModule.flipTextareaToInputField()

root.CourtAddressModule = CourtAddressModule

jQuery ->
  CourtAddressModule.setup()
