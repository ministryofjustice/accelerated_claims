root = exports ? this

CourtAddressModule =

  courtData: ->
    ''

  courtFields: ->
    ['#claim_court_court_name',
     '#claim_court_street',
     '#claim_court_postcode']

  isCourtAddressFormBlank: ->
    for field in CourtAddressModule.courtFields()
      return false if $(field).val() != ''
    true

  addCourtAddressFormLabel: ->
    if CourtAddressModule.isCourtAddressFormBlank()
      label = "You haven't entered a postcode for the property you want to take back. To see the court you need to send this claim to, <a href=\"#property\">enter the postcode now</a>."
      $('#court-address-label').html(label)

  changeElement:(id, tag, new_element) ->
    if $(id).is(tag)
      old_element = $(id)
      new_element = $(new_element)
      new_element.attr({ 'name': "#{old_element.attr('name')}" })
      new_element.val(old_element.val())
      id = old_element.attr('id')
      new_element.insertBefore(old_element)
      old_element.remove()
      new_element.attr({ 'id': id })

  flipTextareaToInputField: ->
    CourtAddressModule.changeElement('#claim_court_street', 'textarea', "<input type='hidden'></input>")

  changeInputFieldToTextarea: ->
    CourtAddressModule.changeElement('#claim_court_street', 'input', '<textarea></textarea>')
    $('#claim_court_street').attr('maxlength', 140)

  hideCourtAddressInputFields: ->
    for field in CourtAddressModule.courtFields()
      CourtAddressModule.changeElement('#' + $(field).attr('id'), 'input', "<input type='hidden'></input>")

    $("#court-address").hide()

  blankFormFields: ->
    for field in CourtAddressModule.courtFields()
      $(field).val('') if $(field).not(':visible')
      CourtAddressModule.changeElement('#' + $(field).attr('id'), 'input', "<input type='text'></input>")

  enableTogglingOfCourtAddressForm: ->
    $("#court-details").click ->
      if $('#claim_court_street').is(':visible')
        CourtAddressModule.flipTextareaToInputField()
        CourtAddressModule.populateCourtDetails()
        $('#court-address').hide()
        CourtAddressModule.hideCourtAddressInputFields()
        $('#court-details').parent().removeClass('open')
      else
        CourtAddressModule.populateCourtAddressForm('', '', '')
        CourtAddressModule.changeInputFieldToTextarea()
        CourtAddressModule.blankFormFields()
        $('#court-address').show()
        $('#court-details').parent().addClass('open')

  showCourtAddressForm: ->
    CourtAddressModule.blankFormFields()
    $("#court-address").show()

  findCourtName: (postcode) ->
    CourtLookup.lookup(postcode, CourtAddressModule)

  populateCourtDetails: ->
    court_name = CourtAddressModule.courtData[0].name
    court_street = CourtAddressModule.courtData[0].address.address_lines
    court_postcode = CourtAddressModule.courtData[0].address.postcode
    court_name_element = $('#court-name')[0]
    court_name_element.innerHTML = "<b class='bold-small'>#{court_name}</b>"
    if CourtAddressModule.courtFormHasErrors()==false || $('#court-address').is(':hidden')
      CourtAddressModule.populateCourtAddressForm(court_name, court_street, court_postcode)
      CourtAddressModule.hideCourtAddressInputFields()
    CourtAddressModule.linkForFormToggling()
    CourtAddressModule.labelForKnownCourt()

  labelForKnownCourt: ->
    label = "You need to post this claim to the court nearest the property you're taking back:"
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
    if $("[id^=court-details]").length == 0
      link = "<p/><a id='court-details' class='caption'>Choose to send this claim to a different court</a>"
      $(link).insertAfter('#court-name')
      CourtAddressModule.enableTogglingOfCourtAddressForm()

  sendPostcodeForLookup: ->
    $('#claim_property_postcode').change ->
      CourtAddressModule.lookUpCourt()

  lookUpCourt: ->
    postcode = $('#claim_property_postcode').val()
    if postcode
      CourtAddressModule.findCourtName postcode
    else
      CourtAddressModule.displayNoResultsFound()

  getCourtIfPostcodePresent: ->
    if CourtAddressModule.isCourtAddressFormBlank()
      postcode = $('#claim_property_postcode').val()
      CourtLookup.lookup(postcode, CourtAddressModule) if postcode
    else
      CourtAddressModule.labelForKnownCourt()
      CourtAddressModule.linkForFormToggling()
      $('#court-name').html("<b class='bold-small'>#{$('#claim_court_court_name').val()}</b>")

  courtFormHasErrors: ->
    result = false
    prefix = 'claim_court'
    values = ['court_name', 'postcode', 'address']

    for val in values
      unless result
        id = "\##{prefix}_#{val}_error"
        if $('#form_errors').find("[data-id='#{id}']").length > 0
          result = true
    return result

  showFormWhenErrors: ->
    if CourtAddressModule.courtFormHasErrors()
      CourtAddressModule.changeElement('#claim_court_court_name', 'input', "<input type='text'></input>")
      CourtAddressModule.changeElement('#claim_court_postcode', 'input', "<input type='text'></input>")
      CourtAddressModule.changeInputFieldToTextarea()
      $('#court-details').parent().addClass('open')
      $('#court-address').show()

  showCourtFormIfNonstandardCourt: ->
    postcode = $('#claim_property_postcode').val()
    if postcode != ''
      separator = "/"
      if window.location.pathname.match(/\/$/)
        separator = ""
      myUrl =  window.location.pathname + separator + "court-address/#{postcode}"
      jQuery.ajax( myUrl,
        success: (data) ->
          submitted_court_name = $('#claim_court_court_name').val()
          submitted_court_street = $('#claim_court_street').val()
          submitted_court_postcode = $('#claim_court_postcode').val()
          if data[0] != undefined
            default_court_name = data[0].name
            default_court_street = data[0].address.address_lines.toString()
            default_court_postcode = data[0].address.postcode
            CourtAddressModule.courtData = data
            if default_court_name != submitted_court_name || default_court_street != submitted_court_street || default_court_postcode != submitted_court_postcode
              CourtAddressModule.changeElement('#claim_court_court_name', 'input', "<input type='text'></input>")
              CourtAddressModule.changeElement('#claim_court_postcode', 'input', "<input type='text'></input>")
              CourtAddressModule.changeInputFieldToTextarea()
              $('#court-details').parent().addClass('open')
              $('#court-address').show()
        error: (jqXHR, textStatus, errorThrown) ->
          CourtAddressModule.displayNoResultsFound()
      )

  addressReEntry: ->
    $('.change-postcode-link').click ->
      CourtAddressModule.blankFormFields()
      CourtAddressModule.addCourtAddressFormLabel()
      $('#court-name').empty()
      $('#court-details').remove()

  setup: ->
    CourtAddressModule.getCourtIfPostcodePresent()
    CourtAddressModule.addCourtAddressFormLabel()
    CourtAddressModule.hideCourtAddressInputFields()
    CourtAddressModule.sendPostcodeForLookup()
    CourtAddressModule.flipTextareaToInputField()
    CourtAddressModule.showFormWhenErrors()
    CourtAddressModule.showCourtFormIfNonstandardCourt()
    CourtAddressModule.addressReEntry()

root.CourtAddressModule = CourtAddressModule

jQuery ->
  CourtAddressModule.setup()
