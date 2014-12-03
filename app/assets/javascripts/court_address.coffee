root = exports ? this

CourtAddressModule =

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
        CourtAddressModule.lookUpCourt()
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

  populateCourtDetails: (data) ->
    console.log('populateCourtDetails')
    console.log('data=' + data[0].name.toString())
    court_name = data[0].name
    court_street = data[0].address.address_lines
    court_postcode = data[0].address.postcode
    court_name_element = $('#court-name')[0]
    court_name_element.innerHTML = "<b>#{court_name}</b>"
    if CourtAddressModule.courtFormHasErrors()==false || $('#court-address').is(':hidden')
      CourtAddressModule.populateCourtAddressForm(court_name, court_street, court_postcode)
      CourtAddressModule.hideCourtAddressInputFields()
    CourtAddressModule.linkForFormToggling()
    CourtAddressModule.labelForKnownCourt()

  labelForKnownCourt: ->
    label = "You need to post this claim to the court nearest \n
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
    if CourtAddressModule.isCourtAddressFormBlank()
      postcode = $('#claim_property_postcode').val()
      CourtLookup.lookup(postcode, CourtAddressModule) if postcode
    else
      CourtAddressModule.labelForKnownCourt()
      CourtAddressModule.linkForFormToggling()
      $('#court-name').html("<b>#{$('#claim_court_court_name').val()}</b>")

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
    submitted_court_name = $('#claim_court_court_name').val()
    submitted_court_street = $('#claim_court_street').val()
    submitted_court_postcode = $('#claim_court_postcode').val()
    console.log(' -- submitted_court_name=' + submitted_court_name)
    console.log(' -- submitted_court_street=' + submitted_court_street)
    console.log(' -- submitted_court_postcode=' + submitted_court_postcode)
    console.log('looking up court from postcode')


    default_court_name = $('#claim_court_court_name').val()
    default_court_street = $('#claim_court_street').val()
    default_court_postcode = $('#claim_court_postcode').val()


    console.log(' -- default_court_name=' + default_court_name)
    console.log(' -- default_court_street=' + default_court_street)
    console.log(' -- default_court_postcode=' + default_court_postcode)

    $('#claim_court_court_name').val(submitted_court_name)
    $('#claim_court_street').val(submitted_court_street)
    $('#claim_court_postcode').val(submitted_court_postcode)
    return 'done'


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
    CourtAddressModule.addressReEntry()

root.CourtAddressModule = CourtAddressModule

jQuery ->
  CourtAddressModule.setup()
