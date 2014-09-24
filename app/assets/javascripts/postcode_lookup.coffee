root = exports ? this

PostcodeLookup =

  lookup: (postcode, view) ->
    result = jQuery.ajax(
      url: 'http://localhost:50859/postcode.json?pc=SW106LV',
      success: (data) ->
        view.displayAddresses(data)
    )

root.PostcodeLookup = PostcodeLookup
