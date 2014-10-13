root = exports ? this

CourtAddressModule =

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

  toggleCourtAddressForm: ->
    $("#court-details").click ->
      for attr_name in ['court_name', 'street', 'postcode']
        form_field = "#claim_court_#{attr_name}"
        $(form_field).attr({ 'type': 'text' }) if $(form_field).attr('type') == 'hidden'
      $("#court-address").toggle()


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
        console.log 'ERROR:' + textStatus

  populateCourtAddressForm: (court_name, court_street, court_postcode) ->
    $('#claim_court_court_name').val(court_name)
    $('#claim_court_street').val(court_street)
    $('#claim_court_postcode').val(court_postcode)

  sendPostcodeForLookup: ->
    $('#claim_property_postcode').bind 'blur', ->
      postcode = document.getElementById('claim_property_postcode')
      CourtAddressModule.findCourtName postcode.value

  setup: ->
    CourtAddressModule.hideCourtAddressInitially()
    CourtAddressModule.sendPostcodeForLookup()
    CourtAddressModule.toggleCourtAddressForm()
    CourtAddressModule.flipTextareaToInputField()

root.CourtAddressModule = CourtAddressModule

jQuery ->
  CourtAddressModule.setup()
