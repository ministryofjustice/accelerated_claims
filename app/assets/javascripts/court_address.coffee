root = exports ? this

CourtAddressModule =

  addCourtAddressFormLabel: ->
    label = "You haven't entered a postcode for the property you want to take back.<br> To see the court you need to send this claim to, <a href=\"#property\">enter the postcode now</a>"
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

  hideCourtAddress: ->
    $('#claim_court_court_name').attr({ 'type': 'hidden' })
    $('#claim_court_postcode').attr({ 'type': 'hidden' })
    $("#court-address").hide()

  blankFormFields: ->
    for attr_name in ['court_name', 'street', 'postcode']
      form_field = "#claim_court_#{attr_name}"
      $(form_field).val('') if $(form_field).not(':visible')
      $(form_field).attr({ 'type': 'text' })

  enableTogglingOfCourtAddressForm: ->
    $("#court-details").click ->
      if $('#claim_court_street').is(':visible')
        CourtAddressModule.flipTextareaToInputField()
        CourtAddressModule.lookUpCourt()
        $('#court-address').hide()
        $('#court-details').parent().addClass('open')
      else
        CourtAddressModule.populateCourtAddressForm('', '', '')
        CourtAddressModule.changeInputFieldToTextarea()
        CourtAddressModule.blankFormFields()
        $('#court-address').show()
        $('#court-details').parent().removeClass('open')


  showCourtAddressForm: ->
    CourtAddressModule.blankFormFields()
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
    CourtAddressModule.labelForKnownCourt()

  labelForKnownCourt: ->
    label = "You need to post this claim to the court nearest \
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
    court_fields = ['#claim_court_court_name',
                    '#claim_court_street',
                    '#claim_court_postcode']
    all_blank = true

    for field in court_fields
      if $(field).val() != ''
        all_blank = false

    if all_blank
      postcode = $('#claim_property_postcode').val()
      if postcode
        CourtLookup.lookup(postcode, CourtAddressModule)

  showFormWhenErrors: ->
    if $('#claim_court_court_name_error')
      $("#court-address").show()
      $("#claim_court_court_name").attr({ 'type': 'text' })

  setup: ->
    CourtAddressModule.getCourtIfPostcodePresent()
    CourtAddressModule.addCourtAddressFormLabel()
    CourtAddressModule.hideCourtAddress()
    CourtAddressModule.sendPostcodeForLookup()
    CourtAddressModule.flipTextareaToInputField()
    CourtAddressModule.showFormWhenErrors()

root.CourtAddressModule = CourtAddressModule

jQuery ->
  CourtAddressModule.setup()
