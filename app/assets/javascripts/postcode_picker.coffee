root = exports ? this

class PostcodePicker

  constructor: (findButton) ->
    findButton.on('click', ->
      window.PostcodeLookup.lookup()
    )

root.PostcodePicker = PostcodePicker


jQuery ->
   _.each $('.postcode-picker-button'), (findButton) ->
     new PostcodePicker(findButton)
