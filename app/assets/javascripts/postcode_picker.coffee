//= require 'postcode_lookup'

root = exports ? this

class PostcodePicker

  constructor: (picker) ->
    @picker = picker
    @selectElement = @picker.find('.address-picker-select')
    @button = picker.find('.postcode-picker-button')
    input = picker.find('.postcode-picker-edit-field')
    manualLink = picker.find('.postcode-picker-manual-link')
    selectButton = picker.find('.postcode-picker-cta')

    @button.on 'click', =>
      postcode = input.val()
      window.PostcodeLookup.lookup(postcode, this)

    input.on 'keyup', =>
      @clearPostcodeErrorMessage()

    selectButton.on 'click', =>
      @selectAddress()

  selectAddress: =>
    index = parseInt @picker.find('option:selected').val()
    selectedAddress = @addresses[index]
    street = selectedAddress.address.replace(/;;/g, "\n")
    postcode = selectedAddress.postcode

    @picker.find('.street textarea').val(street)
    @picker.find('.postcode input').val(postcode)
    @picker.find('.postcode-picker-address-list').hide()
    @picker.find('.postcode-picker-manual-link').hide()
    @picker.find( '.address.details' ).addClass('open')

  displayAddresses: (addresses) ->
    @addresses = addresses
    @selectElement.empty()
    @selectElement.append '<option disabled="disabled" value="">Please select an address</option>'
    $.each addresses, (index, address) =>
      address = address.address.replace(/;;/g, ", ")
      option = "<option value=\"#{index}\">#{address}</option>"
      @selectElement.append option
    @picker.find('.postcode-select-container').show()

  displayAddressFields: ->
    @picker.find('.postcode-lookup').hide()
    @picker.find('.address').show()

  displayInvalidPostcodeMessage: ->
    @addErrorMessage('Please enter a valid UK postcode')

  displayNoResultsFound: ->
    @addErrorMessage('No address found. Please enter the address manually')

  displayServiceUnavailable: ->
    @displayAddressFields()
    @picker.find('.street').before("<div class='row'><span class=\"error postcode\">Postcode lookup service not available. Please enter the address manually.</span></div>")

  clearPostcodeErrorMessage: ->
    @picker.find('.error.postcode').detach()

  addErrorMessage: (text) ->
    @clearPostcodeErrorMessage()
    @button.after("<span class=\"error postcode\">#{text}</span>")

root.PostcodePicker = PostcodePicker

jQuery ->
   _.each $('.postcode-picker-container'), (picker) ->
     new PostcodePicker( $(picker) )

