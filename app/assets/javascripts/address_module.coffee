root = exports ? this

AddressModule = 
	countNewlines: (str) ->
  	n = 0
  	i = 0
  	while (pos = str.indexOf("\n", i)) != -1
    	n += 1
    	i = pos + 1
  	n


  bindToAddressBoxes: ->
    address_boxes = [
      'claim_property_street'
    ]
    for address_box in address_boxes
      $("##{address_box}").on 'keyup', ->
        AddressModule.hideErrorFor(address_box)
        string = $(this).val()
        num_newlines = AddressModule.countNewlines(string)
        if ( num_newlines == 4 && AddressModule.lastLineIsntWhiteSpace(string) ) || (num_newlines > 4) 
          AddressModule.showErrorFor(address_box)
      	

  showErrorFor: (address_box) ->
    $("##{address_box}-error-message").show()

  hideErrorFor: (address_box) ->
    $("##{address_box}-error-message").hide()



  iterateOverArray: ->
    ary = [
      'this', 
      'that', 
      'this and that',
      'the other'
    ]
    for thing in ary
      console.log(thing)


  setup: ->
    console.log("AddressModule.setup")
    AddressModule.bindToAddressBoxes()
    AddressModule.iterateOverArray()


  lastLineIsntWhiteSpace: (str) ->
  	match = /\n\s*$/.test(str)
  	!match
    


root.AddressModule = AddressModule

jQuery ->
  AddressModule.setup()




