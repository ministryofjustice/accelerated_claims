//= require 'postcode_lookup'

root = exports ? this

class PostcodePicker

  constructor: (picker) ->
    @picker = picker
    button = picker.find('.postcode-picker-button')
    input = picker.find('.postcode-picker-edit-field')

    button.on('click', =>
      postcode = input.val()
      window.PostcodeLookup.lookup(postcode, this)
    )

  displayAddresses: (addresses) ->
    selectElement = @picker.find('.address-picker-select')
    $.each addresses, (index, address) ->
      address = address.address.replace(/;;/g, ", ")
      option = "<option value=\"#{index}\">#{address}</option>"
      selectElement.append option
    @picker.find('.property-postcode-select-container').removeClass('hide')

root.PostcodePicker = PostcodePicker


jQuery ->
   _.each $('.postcode-picker-container'), (picker) ->
     new PostcodePicker( $(picker) )
