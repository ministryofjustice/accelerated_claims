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
    _.each $('div.street textarea'), (el) ->
      AddressModule.checkNewlines(el)
      

  checkNewlines: (element) ->
    $(element).on 'keyup', ->
      element_id = element.getAttribute('id')
      AddressModule.hideErrorFor(element_id)
      string = $(this).val()
      num_newlines = AddressModule.countNewlines(string)
      if ( num_newlines == 4 && AddressModule.lastLineIsntWhiteSpace(string) ) || (num_newlines > 4) 
        AddressModule.showErrorFor(element_id)
        


  showErrorFor: (address_box) ->
    $("##{address_box}-error-message").show()

  hideErrorFor: (address_box) ->
    $("##{address_box}-error-message").hide()



  setup: ->
    AddressModule.bindToAddressBoxes()


  lastLineIsntWhiteSpace: (str) ->
  	match = /\n\s*$/.test(str)
  	!match
    


root.AddressModule = AddressModule

jQuery ->
  AddressModule.setup()




