root = exports ? this

PropertyModule = 

  hideOrShowRoomNumberPrompt: ->
    typeOfProperty = $("#claim_property_house_no")
    isHmo = typeOfProperty.is(':checked')
    if isHmo
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


root.PropertyModule = PropertyModule

jQuery ->
  PropertyModule.setup()