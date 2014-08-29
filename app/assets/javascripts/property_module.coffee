root = exports ? this

PropertyModule =

  hideOrShowRoomNumberPrompt: ->
    multipleOccupancy = $("#claim_property_house_no").is(':checked')

    if multipleOccupancy
      PropertyModule.showRoomNumberPrompt()
    else
      PropertyModule.hideRoomNumberPrompt()

  hideRoomNumberPrompt: ->
    $('#room_number').hide()

  showRoomNumberPrompt: ->
    $('#room_number').show()

  bindTypeOfProperty: ->
    $("#claim_property_house_no").on "change", ->
      PropertyModule.hideOrShowRoomNumberPrompt()
    $("#claim_property_house_yes").on "change", ->
      PropertyModule.hideOrShowRoomNumberPrompt()

  setup: ->
    PropertyModule.bindTypeOfProperty()
    PropertyModule.hideOrShowRoomNumberPrompt()

root.PropertyModule = PropertyModule

jQuery ->
  PropertyModule.setup()