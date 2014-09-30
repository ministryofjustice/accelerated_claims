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
      @picker.find('.postcode-selection-els').show()
      @input.val('')
      @input.focus()

  lookupPostcode: =>
    postcode = @input.val()
    @picker.find('.postcode-select-container').hide()
    window.PostcodeLookup.lookup(postcode, this)

  selectAddress: =>
    index = parseInt @picker.find('option:selected').val()
    selectedAddress = @addresses[index]
    street = selectedAddress.address.replace(/;;/g, "\n")
    postcode = selectedAddress.postcode

    @picker.find('.street textarea').val(street)
    @picker.find('.postcode input').val(postcode)
    @picker.find('.postcode-picker-address-list').hide()
    @picker.find('.postcode-picker-manual-link').hide()
    @picker.find('.address.extra' ).show()
    @picker.find('.postcode-selection-els').hide()
    @picker.find('.street textarea').focus()

  displayAddresses: (addresses) ->
    @hideAddressFields()
    @addresses = addresses
    @selectElement.empty()
    @selectElement.append '<option disabled="disabled" value="">Please select an address</option>'
    @input.val(addresses[0].postcode)
    $.each addresses, (index, address) =>
      address = address.address.replace(/;;/g, ", ")
      option = "<option value=\"#{index}\">#{address}</option>"
      @selectElement.append option
    @picker.find('.postcode-select-container').show()
    @picker.find('.postcode-picker-address-list').show()

    

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

