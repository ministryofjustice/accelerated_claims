root = exports ? this

PostcodePicker =

  bindToFindPostcodeButton: ->
    console.log("PostcodePicker bindToFindPostcodeButton")
    _.each $('.postcode-picker-button'), (el) ->
      PostcodePicker.actionFindPostcodeClicked()

  actionFindPostcodeClicked: ->
    console.log('on click' + $(this))

  setup: ->
    # console.log("PostcodePickerModule setup")
    PostcodePicker.bindToFindPostcodeButton()


root.PostcodePicker = PostcodePicker

jQuery ->
  PostcodePicker.setup()