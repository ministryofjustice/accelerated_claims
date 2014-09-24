root = exports ? this

PostcodePickerModule =

  bindToFindPostcodeButton: ->
    console.log("PostcodePickerModule bindToFindPostcodeButton")
    _.each $('.postcode-picker-button'), (el) ->
      PostcodePickerModule.actionFindPostcodeClicked()

  actionFindPostcodeClicked: ->
    console.log('on click' + $(this))

  setup: ->
    # console.log("PostcodePickerModule setup")
    PostcodePickerModule.bindToFindPostcodeButton()


root.PostcodePickerModule = PostcodePickerModule

jQuery ->
  PostcodePickerModule.setup()