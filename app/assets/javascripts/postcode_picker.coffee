root = exports ? this

class PostcodePicker

  constructor: (picker) ->
    button = picker.find('.postcode-picker-button')
    input = picker.find('.postcode-picker-edit-field')

    button.on('click', =>
      postcode = input.val()
      window.PostcodeLookup.lookup(postcode, this)
    )

root.PostcodePicker = PostcodePicker


jQuery ->
   _.each $('.postcode-picker-container'), (picker) ->
     new PostcodePicker(picker)
