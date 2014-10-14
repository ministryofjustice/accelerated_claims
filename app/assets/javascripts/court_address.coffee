root = exports ? this

CourtAddressModule =

  addCourtAddressFormLabel: ->
    label = "You need to post this claim to the court nearest the property you're taking back:"
    $('#court-address-label').text(label)

  flipTextareaToInputField: ->
    if $('#claim_court_address').is("textarea")
      text_area = $('#claim_court_street')
      input_element = $("<input type='hidden'></input>")
      console.log "the value of #claim_court_street: #{text_area.val()}"
      input_element.attr({ 'name': "#{text_area.attr('name')}" })
      input_element.val("#{text_area.val()}")
      id = "#{text_area.attr('id')}"
      input_element.insertBefore(text_area)
      text_area.remove()
      input_element.attr({ 'id': "#{id}" })

  hideCourtAddressInitially: ->
    $('#claim_court_court_name').attr({ 'type': 'hidden' })
    $('#claim_court_postcode').attr({ 'type': 'hidden' })
    $("#court-address").hide()

  flipVisibilityOfCourtAddressForm: ->
    for attr_name in ['court_name', 'street', 'postcode']
        form_field = "#claim_court_#{attr_name}"
        $(form_field).attr({ 'type': 'text' }) if $(form_field).attr('type') == 'hidden'

  toggleCourtAddressForm: ->
    $("#court-details").click ->
      CourtAddressModule.flipVisibilityOfCourtAddressForm()
      $("#court-address").toggle()

  showCourtAddressForm: ->
    CourtAddressModule.flipVisibilityOfCourtAddressForm()
    $("#court-address").show()

  findCourtName: (postcode) ->
    url = "/court-address/#{postcode}"
    jQuery.ajax url,
      type: 'GET'
      success: (data) ->
        court_name = data[0].name
        court_street = data[0].address.address_lines
        court_postcode = data[0].address.postcode
        court_name_element = $('#court-name')[0]
        court_name_element.innerHTML = "<b>#{court_name}</b>"
        CourtAddressModule.populateCourtAddressForm(court_name, court_street, court_postcode)
      error: (jqXHR, textStatus, errorThrown) ->
        CourtAddressModule.addOriginalFormLabelText()
        CourtAddressModule.showCourtAddressForm()

  addOriginalFormLabelText: ->
    label = 'Enter the name and address of the court you want to send this claim to.'
    $('#court-address-label').text(label)

  populateCourtAddressForm: (court_name, court_street, court_postcode) ->
    $('#claim_court_court_name').val(court_name)
    $('#claim_court_street').val(court_street)
    $('#claim_court_postcode').val(court_postcode)

  sendPostcodeForLookup: ->
    $('#claim_property_postcode').bind 'blur', ->
      postcode = document.getElementById('claim_property_postcode')
      CourtAddressModule.findCourtName postcode.value

  setup: ->
    CourtAddressModule.addCourtAddressFormLabel()
    CourtAddressModule.hideCourtAddressInitially()
    CourtAddressModule.sendPostcodeForLookup()
    CourtAddressModule.toggleCourtAddressForm()
    CourtAddressModule.flipTextareaToInputField()

root.CourtAddressModule = CourtAddressModule

jQuery ->
  CourtAddressModule.setup()
