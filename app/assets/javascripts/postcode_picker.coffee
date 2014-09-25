//= require 'postcode_lookup'

root = exports ? this

class PostcodePicker

  constructor: (picker) ->
    @picker = picker
    @selectElement = @picker.find('.address-picker-select')
    @button = picker.find('.postcode-picker-button')
    input = picker.find('.postcode-picker-edit-field')

    @button.on('click', =>
      postcode = input.val()
      window.PostcodeLookup.lookup(postcode, this)
    )

    input.on 'keyup', =>
      @picker.find('.error.postcode').detach()

  displayAddresses: (addresses) ->
    @selectElement.empty()
    @selectElement.append '<option disabled="disabled" value="">Please select an address</option>'
    $.each addresses, (index, address) =>
      address = address.address.replace(/;;/g, ", ")
      option = "<option value=\"#{index}\">#{address}</option>"
      @selectElement.append option
    @picker.find('.property-postcode-select-container').removeClass('hide')

  displayInvalidPostcodeMessage: ->
    @button.after('<span class="error postcode">That is an invalid postcode!</span>')



root.PostcodePicker = PostcodePicker


jQuery ->
   _.each $('.postcode-picker-container'), (picker) ->
     new PostcodePicker( $(picker) )

