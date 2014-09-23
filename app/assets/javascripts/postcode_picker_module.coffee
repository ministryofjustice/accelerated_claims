root = exports ? this

PostcodePickerModule =

  bindToFindPostcodeButton: ->
     _.each $('.postcode-picker-button'), (el) ->
      PostcodePickerModule.actionFindPostcodeClicked

  actionFindPostcodeClicked: ->
    console.log('on click' + $(this))

  setup: ->
    PostcodePickerModule.bindToFindPostcodeButton()


root.PostcodePickerModule = PostcodePickerModule

jQuery ->
  PostcodePickerModule.setup()