root = exports ? this

AddressModule = 
  bindToAddressBoxes: ->
    $('#claim_property_street').on 'keyup', ->
      string = $(this).val()
      console.log(string)


  setup: ->
    console.log("AddressModule.setup")
    AddressModule.bindToAddressBoxes()
    


root.AddressModule = AddressModule

jQuery ->
  AddressModule.setup()