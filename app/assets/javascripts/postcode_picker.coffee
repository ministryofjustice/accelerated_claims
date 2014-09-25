//= require 'postcode_lookup'

root = exports ? this

class PostcodePicker

  constructor: (picker) ->
    @picker = picker
    @selectElement = @picker.find('.address-picker-select')
    @button = picker.find('.postcode-picker-button')
    input = picker.find('.postcode-picker-edit-field')
    manualLink = picker.find('.postcode-picker-manual-link')

    @button.on 'click', =>
      postcode = input.val()
      window.PostcodeLookup.lookup(postcode, this)

    manualLink.on 'click', =>
      @picker.find('.postcode-lookup').hide()
      address = @picker.find('.address')
      address.show()
      false

    input.on 'keyup', =>
      @clearPostcodeErrorMessage()

  displayAddresses: (addresses) ->
    @selectElement.empty()
    @selectElement.append '<option disabled="disabled" value="">Please select an address</option>'
    $.each addresses, (index, address) =>
      address = address.address.replace(/;;/g, ", ")
      option = "<option value=\"#{index}\">#{address}</option>"
      @selectElement.append option
    @picker.find('.postcode-select-container').show()

  displayInvalidPostcodeMessage: ->
    @addErrorMessage('That is an invalid postcode!')

  displayNoResultsFound: ->
    @addErrorMessage('No addresses for that postcode!')

  clearPostcodeErrorMessage: ->
    @picker.find('.error.postcode').detach()

  addErrorMessage: (text) ->
    @clearPostcodeErrorMessage()
    @button.after("<span class=\"error postcode\">#{text}</span>")


root.PostcodePicker = PostcodePicker


jQuery ->
   _.each $('.postcode-picker-container'), (picker) ->
     new PostcodePicker( $(picker) )

