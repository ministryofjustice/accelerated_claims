//= require 'postcode_lookup'

root = exports ? this

class PostcodePicker

  constructor: (picker) ->
    @picker = picker
    @selectElement = @picker.find('.address-picker-select')
    @button = picker.find('.postcode-picker-button')
    @input = picker.find('.postcode-picker-edit-field')
    manualLink = picker.find('.postcode-picker-manual-link')
    selectButton = picker.find('.postcode-picker-cta')
    changePostcodeLink = picker.find('.change-postcode-link')
    changePostcodeLink2 = picker.find('.change-postcode-link2')

    # if the postcode is populated, then it means that the address was correctly selected earlier
    # and we want to display it.
    if @picker.find('input.smalltext.postcode').val() != ''
      @picker.find('.address.extra' ).show()
      @picker.find('.postcode-selection-els').hide()
      @picker.find('.postcode-display').hide()
      @hideManualLink()



    @button.on 'click', =>
      @lookupPostcode()

    manualLink.on 'click', =>
      @toggleAddressFields()

    @input.on 'keyup', =>
      @clearPostcodeErrorMessage()

    selectButton.on 'click', =>
      @selectAddress()

    changePostcodeLink.on 'click', =>
      @hideAddressFields()
      @showManualLink()
      @picker.find('.postcode-selection-els').show()
      @input.val('')
      @input.focus()
      

    changePostcodeLink2.on 'click', =>
      @picker.find('.postcode-display').addClass('hide')
      @picker.find('.postcode-select-container').hide()
      @showPostcodeSearchComponent()
   

  hideManualLink: =>
    @picker.find('.postcode-picker-manual-link').hide()

  showManualLink: =>
    @picker.find('.postcode-picker-manual-link').show()

  lookupPostcode: =>
    postcode = @input.val()
    @picker.find('.postcode-display').show()
    @picker.find('.postcode-select-container').hide()
    @showManualLink()
    window.PostcodeLookup.lookup(postcode, this)

  selectAddress: =>
    index = parseInt @picker.find('option:selected').val()
    selectedAddress = @addresses[index]
    street = selectedAddress.address.replace(/;;/g, "\n")
    postcode = selectedAddress.postcode

    @picker.find('.street textarea').val(street)
    @picker.find('.postcode input').val(postcode)
    @picker.find('.postcode-picker-address-list').hide()
    
    @picker.find('.address.extra' ).show()
    @picker.find('.postcode-selection-els').hide()
    @picker.find('.postcode-display').hide()
    @hideManualLink()
    @picker.find('.street textarea').focus()

  displayAddresses: (addresses) ->
    @hideAddressFields()
    @hidePostcodeSearchComponent()
    @addresses = addresses
    @selectElement.empty()
    @picker.find('.postcode-display').removeClass('hide')
    @picker.find('.postcode-display-detail').html(addresses[0].postcode)
    $.each addresses, (index, address) =>
      address = address.address.replace(/;;/g, ", ")
      option = "<option value=\"#{index}\">#{address}</option>"
      @selectElement.append option
    @picker.find('.postcode-select-container').show()
    @picker.find('.address-picker-select').focus()
    true

    
  hidePostcodeSearchComponent: ->
    @picker.find('.postcode-selection-els').hide()

  showPostcodeSearchComponent: ->
    @picker.find('.postcode-selection-els').show()
    @input.focus()
    true



  toggleAddressFields: ->
    if @picker.find('.address').is(':visible')
      @hideAddressFields()
    else
      @displayAddressFields()

  hideAddressFields: ->
    @picker.find('.address').hide()
    @picker.find('.postcode-picker-manual-link').parent().removeClass('open')

  displayAddressFields: ->
    @picker.find('.street').val('')
    @picker.find('.postcode').val('')
    @picker.find('.address').show()
    @picker.find('.postcode-picker-manual-link').parent().addClass('open')
    @picker.find('.street textarea').focus()

  displayInvalidPostcodeMessage: ->
    @addErrorMessage('Please enter a valid UK postcode')
    @hideAddressFields()

  displayNoResultsFound: ->
    @addErrorMessage('No address found. Please enter the address manually')
    @displayAddressFields()

  displayServiceUnavailable: ->
    @displayAddressFields()
    @addErrorMessage('Postcode lookup service not available. Please enter the address manually.')

  clearPostcodeErrorMessage: ->
    @picker.find('.error.postcode').detach()

  addErrorMessage: (text) ->
    @clearPostcodeErrorMessage()
    @button.after("<span class=\"error postcode\">#{text}</span>")

root.PostcodePicker = PostcodePicker

jQuery ->
   _.each $('.postcode-picker-container'), (picker) ->
     new PostcodePicker( $(picker) )

